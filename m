Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042F360A263E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=FpkQRBOI
Received: by kanga.kvack.org (Postfix)
	id 044E36B05CD; Sat, 14 Nov 2026 15:06:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36C86B05CE; Sat, 14 Nov 2026 15:05:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26626B05CF; Sat, 14 Nov 2026 15:05:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5E866B05CD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:05:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A0C7120464
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:05:59 +0000 (UTC)
X-FDA: 85434805638.24.596F7D5
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4AFE720004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:05:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=FpkQRBOI;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf03.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
	b=jbMpWMTTuN1ilQkQlgaVy5T091kKnLlQZMNxVNRuKixgKebXSacCsVGiYr/MfDS12xOOYZ
	HvNzthCPRpuStvBC3Q9So/x76/ZmjW1JHH47hvTpt5eSEVIHXVY2dxfg6i65l8zvVg+UHp
	CWFn9a4KILhyqhwx3f1foo2cbb+b/II=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=FpkQRBOI;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf03.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686757;
	b=HuctGcurnSj4o0fm+bvrX3iw44zQ9lhRzO2j9jf8AJVDmDVyskdc1wkIBNBjj70faOWU+B
	a4hBUX5a7GepfUXr6nNJ3PDROtonnbFWyef41f2a7Y3HVXB3+2azmitaxyWp/qxzhxMKOW
	rrps6aRTf//1gMIdLPd4XbIfiu1DEMQ=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a070755c8cso1295173b3a.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686756; x=1795291556; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=FpkQRBOIuZgzYA29XniQqB64y+kg3M9wyUYoBbNBabsAErDxyk+8Wj/RAIbe4Mjo7O
         2dXetOOewnMMaWsi3cZ0L0lPN082d58vZ4cFAV+ZsUyNoejqONYVUqNkB/9xMTs9WwLH
         WUzhw0tWvgusGNWTMUEENhlP4E0CDGj5dChqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686756; x=1795291556;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=C/U0X/J4T0abf0XuXY8qmWIJEQ6YTOLr/wlfhdIZJJ9Nbo5gfH+XnnnBRlCIUh+kEZ
         ILybJa2RTY+CnmE75LB1u6d39R+WcwX1NfGsmFX96V9eY8qmZkj54ZYP48pF575K2jp5
         BrEVupLa0YnDc5R0vAz5Vjn/RwS0eZQUvISEP9uhSpwmxY3swFUQpv3lAO1bVFOEpZl5
         f5ftuIjdoPmkixlHoafeGWQa52qavPxu10GvXZ2J/q6+4FyHgNMMbR5uVAHTZ7+u9EQL
         NabP22Uo6ygHoG2FrL8e268pxOEBwabkqPY59waNBmSCpwkko4MbT35HbXevyXTqZcsR
         6wUg==
X-Forwarded-Encrypted: i=1; AL+hErEJFIn+m280JSXMqlgYz2Twb90aeDgfb9tTkqXEHkvxtjply8Qi5ARvtwtPG2umaje7UT3/sZ6+sw==@kvack.org
X-Gm-Message-State: APuU4Z/1MbS9gW28w2yFXoXkej1EeBbMheVU8YdNNtPVEhk/pCB3zRTj
	6er4KOvhEXsntBH434WVX295uBUKRaauyY9fUQ6APt++ljhRgYqNIVGuvFJOqi0vNACOdiQREqa
	pwa3vDnNOWeNmZbw=
X-Gm-Gg: AYBFou3n3kmfxjmPViJI9B2cpPRE4TyP8qUdje/qnZXlp5N12QsNNxHARgfggkDobEb
	vso2pSrPHi/wpPf347JOq1blgMrpWts81J+fhiWV8q99DhYrJJNKwwLF5Der8kIW61fYVNQ6rzZ
	JKZmqQDhjqdCNY8i8xf+iJ8NlwwcVGGYr1yHpJJ4Ugq5I0oLtTLpG2tuMabaRFaEwDSBpswr+qf
	fLat7OzQOjZW4Z+OcccAGmmthkLV5WXuZE3sC6a1wN++vYx+jv7MpbxvmNZxjL8wNh4vgO3otHi
	GSCIgCCfuonpZvbtWMtQJ4+mfo/+S5EB3j2Aa/pvOWnqUsW0CvkbO0NIzpWY/LuTf1nA6Y1sB+Q
	Xl0SKl5FFnmS0+VVH9RadgOm4YD4PzW0xBUjDm6U+qs0XpMB0qFrtq8tlfpRD+VavSWz1Iy3Nme
	rW6vPz5M/uuE0JPlSm3g3shDH39eCHqnXvs1ga0nvGF/qeXur4iP3whZWPgg4gTBBxyAJjdJJ78
	gLeiFCTX2hSJRJDTB9eaL/ppHaNrrG1TSAXxKZWzzk0pEArYnsiPOl6quFouvq3U7Hb9LOeIQ6+
	xx8sGGASCEsg+0emc8fyG4R6S30Zwd7NqegR8GKuxcF91ByKV0m3fRjNauhLO7G2ooUIi1GyTtt
	Rcwv+e89qEc4OX9PiQculV6V8Y9HyVqkISSSCDJaRSktzIw1aQLc1nyKbE8VbqJFTNbj0flwlrx
	XdHFSKDakvhxxDAjDrewn8iZ2Y1HALwOm598yhjb4feqRe0/Sk1P1Nnkig
X-Received: by 2002:a05:6a21:748b:b0:3e3:37ff:3795 with SMTP id adf61e73a8af0-3f7a4dbfbbfmr5517650637.7.1794686756009;
        Sat, 14 Nov 2026 12:05:56 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8172sm2271197b3a.13.2026.11.14.12.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:54 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:50 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org, Alexander Mikhalitsyn <alex@amutable.com>,
	Breno Leitao <leitao@debian.org>, Casey Schaufler <casey@schaufler-ca.com>,
	Chuck Lever <cel@kernel.org>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH RFC v2 00/42] fs: don't use pseudo filesystem files as
	storage
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120550.0c9e73aa12a3072c@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4AFE720004
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6gjuty5pqxpit6di5hgen3u4y1e83onh
X-HE-Tag: 1794686757-265707
X-HE-Meta: U2FsdGVkX194RzxduPTRUDZrKdlbNaevPIlkx1COmmPUwo3Evi7m5tENIMk2OpvDZD7RDBJm4r/BWfIPoiYJmefuJm9QcW9UDnTvD+xsq5iwqLjgoNZM4xaXe1CQGFW+P+HYlS+G6I0Dvp1gy291JtbMyXaVKHdpPd+9GhRrBftyxy+tkqnAw3GDYcE4I4z8svV1uih0oD2IO4ZBvYJJ+qSAxqen3jHuhWOS59Yby74sgsJ/pzXiIJWa2iQGUtthzPZck4LD2bP1GbsBz3gRosa0dV8Y1nHltOENdYsh3IKr6f1VMXzWaKGWrLHcoY9GFJxFY9gBdFvcH/ihbHxEf9hCiWTJnmBveHDeed8v9/TnOroqdKmZfjk/VC+mMlqwf+LaQr0Bu5WBZ2NyHC/GMJLpV4MzLRWvB7Ho9GXO1GrAwrJR5Cw3oEWonFNADeFDwSQx6c2aAseT1PiijIdOci6MEskdH3g9Nek5ylsf7DzEgruZ8BpFZyST8g4qsUeFiVxjWqpLcRAfKcwodtGNHrEav/MPdaHc3Rt2T3cQNh7+P8XTCt0EcGeM5sWT76rCP6g7zqdZrwzFx52UHxEw7NqPUPtH/aXOBqgdxqS+V2IX0bgcj6U+1WkLzJFTiG4XdqYmQUQK3+XNYKduIiMmshb4pOl0y2xKI9BhpbMWUrCVX7FRD+Ln5flrMQhvzlha6PH4FAA+9VpDTl2uiXwnqnEfChUADOMANZomRPTPbUEmVec81Lhjq3GbjjkKydptmwpMohnZ+NLMRrBf0ohDEpKhtZCqx24s8BoqaPqY6loK4dSfahNgu9zaNN49JRt5DxPNWE4BA3NULj4d+3xJAlLxGzp4pUfqxRKQ7d4hpgpv4lb/NgrU3+3L8R9uXgtarilLtng5slD2CCgRs75l6tF16r0fBQ+0OX17FfW2DftPRFcLVF+QP01SE34rRR4TGFamwg/lLRazma40Mul
 p8SPkIEJ
 vqMBO7St8SbnEq3qUgiKqIjf0zkwnAIqGSB5npDYJYhmExXv8JWJkQbsy+JQPgoG9TPzJ0hiLKWLX0LtF19fhMiBJchUQoYB0rS+xAJJrXkJMAoWPEwT1T1gpzmOGjxiPVkNXbfpvHJWWRD7FimOkRsaGrxMbLEqzUWMRBZtAotobP5ucxkCWel4HmwmczQiw3EbTd1dB6IVYpJ2MYMQLg9IQr8I7zzydYhVaszi06hXLbpSVRjpYmbYNAQsGChBoXRexwU4BgQa+KICko4tXBWAgbwNR36g9ckV2lnFdPPITV4DTYsdWC8Ex0+RTgu5rOsCkFw/h3nl05/UsaSOYPXsPQsEABTpFqam0b5W4MAFSyAoU2TcOw3nU0Yjo8j1ntqdvpJhBtevDNhzg33F3OjfFkkqwydU0KU7rEAn9Tq4W/+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christian,

Patches 1-11, 13-16, 18-26, 28, 31, 32, 34-37 and 39-42 look good to me,
so for those please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

I've also tested 5, 6, 34-37, 41 and 42. The selftests all pass with the
series applied, and a uid 0 without capabilities can no longer change
/sys/kernel/reboot/mode through a loop device. So for those, please also
feel free to add:

Tested-by: Chris Down <chris@chrisdown.name>

I've replied separately to 17 and 33.

Thanks!

Chris

