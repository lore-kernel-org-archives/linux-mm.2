Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF32CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 09:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8CD8E004C; Mon,  3 Nov 2025 04:25:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6685B8E002A; Mon,  3 Nov 2025 04:25:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556F18E004C; Mon,  3 Nov 2025 04:25:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E55D8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 04:25:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6045C0AFA
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:25:43 +0000 (UTC)
X-FDA: 84068763366.19.3218A52
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id C7A3F40004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:25:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cLwTUyRV;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762161942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tf1fBcrky/yZyqREIk7CKv1sKuqf+jaJkSHB1INt7Xo=;
	b=zT8451K5qDhb47IuiwYRuP08Co/j6v9acIdEGVBp9XS4iosGSRPSMc+ItVKiaJTJXLgDkU
	WGRQEukj5LgidIJ5J+uj48ikOmlLaapp+lccw+e0FVKzLyx8611Z0jQ1o9YKybVyFApqNQ
	zpdVw7/8iqKXOTY3cd1Vy06qUbloyy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762161942; a=rsa-sha256;
	cv=none;
	b=gizfNZoBeHXpJ0ZqD9M9RkOdcQgzc3QbUMd3ktPxfZi2HbyVvhYkCK9I9v9SZkGLs/+Pb8
	JsWM3N+i7G2ohDAW+gfT4QNtK7Io6INAoXwaqBRmXFZjaaeagSKIlqTPKhJ9+tm9SGZ2JP
	8MqjYQW2LvQSxHzwUrm0KzL+a6qVIek=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cLwTUyRV;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640b9c7eab9so1363839a12.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 01:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762161940; x=1762766740; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tf1fBcrky/yZyqREIk7CKv1sKuqf+jaJkSHB1INt7Xo=;
        b=cLwTUyRV89J4vNcvI+Ap+bruTSnwUW8DZj7FZ8/MdZ9YlOepVCsS3ylxIrXZbiNSGQ
         Q2GSqrvGz+kKFCq58xbB8FJtOT5anK9F+UeDPV8vPpy0F7XW3EITRgHdulNSpcIvlpLz
         NxvjsW+MM/sDdd77EVKa6GhQo+c1lvrTjXPeB71KBQB+gTEQI1n3VFo7gieWe7Ll3Em9
         Tk/zQigd6Ox945EQHYHVLqyGhn1/fw9HeWu2uU6yN3lqn37ynEFIY6amgkDoW0kZRHjH
         5ia3U3jl9DFZWogCVFt9psQjdU3961jVxQazF7A6gF7msYFCYBt996+xVvkCIiWm5ttx
         layA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762161940; x=1762766740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tf1fBcrky/yZyqREIk7CKv1sKuqf+jaJkSHB1INt7Xo=;
        b=gFNpWzouK8QPRvSLJv/AfsQBxrf0pkKWXS/6GUjWlDhmcjmwoTfse+4OAfaj9uguOG
         3UE0Wbs0qRkcwM/O0XXjeyuaDt03ToAyvPbnJJdAJL1h1gU+FfmpoOMYvsP+P7A/FJtb
         p0LOlhmAqBx9Oq7eTED4f500bDwqg1DC1zpfGbFf5b17somsg4G1i50LXxuaBHAErDxd
         lk0FVdJ0Hjfr6Co7QIM+J1WX/1gPRdUA36PdY3RX2TjiAATwNJRE2ZZNjOJKuDoeSRBf
         L94ECYRLUV3Z5+Rxxd0+hfUSX25vqFM7GDBpgbuHdwy2yRei2IK33/sIHiT8OodPR/+5
         HUvQ==
X-Forwarded-Encrypted: i=1; AJvYcCX96xlu8gjN6PsMXkFzO5/QS9mtDSD8S3hGVEdlQ0DfYAWStZqusVfNexA6rUWMEAheU2t1rm7pjg==@kvack.org
X-Gm-Message-State: AOJu0YyOTv6ay0i4EkTiZYNSDK3ZSzg75Ba+au+6mlJNMCQ5UzeuVctA
	ppbGOBBMwzOel2vyvklVXNIvAqQrXnHufK55BXCh8CZnRgvClbC+duItjM5yUgI+Vkk=
X-Gm-Gg: ASbGncsF0mk9dtI40oXh6Kt+bh/MDgLXmkqiwLlMUahIBjmyguJ+fuBke0nafGFmI/p
	FxaFWB6+m900mxa7DpSl0nYKDJUmj4VbLnVv0M4sk2CbOyu6aLhe1Ury/i2hq1kal62pftwRbTQ
	i9nD2t8zedDLwy5aqaa77SGNx5r3NTYCYLmE0q5SmTZ1gAQ3Qt0c1XJtoWmwu9I55DYWo2XmAgh
	SknOHaszskboabmZn9jZkKq8qMrlvVdcDmMAR/rhK5Gu439wVCS/RK58sdBJhqwQ8LcBbRVQHVB
	P45Oul5865novH/MdFga0eoCYlkWCaChBdXkMwmCgLhGyYxUUjXcsdUxls37XQmuP8ss4R+FrfM
	GguG0P5/6tOha03npHTlGyR3JjSVYezhzwl5nZ0ZH3RK+IFQeXvMOVR6Ny916fJohM/vHbeB2hz
	PnG3Y+mBBes/9nbBH3+0yR8zPW
X-Google-Smtp-Source: AGHT+IE3Y2Ge+uwa7x5U2G0gOCZBTHF+519C6h1q7EcMJI2PKxCdrSAv7+sBGhcTO/PZD6VINsLsbA==
X-Received: by 2002:a05:6402:3509:b0:640:c918:e34 with SMTP id 4fb4d7f45d1cf-640c91812a5mr1477004a12.0.1762161940248;
        Mon, 03 Nov 2025 01:25:40 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6407b42821bsm9171075a12.22.2025.11.03.01.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 01:25:39 -0800 (PST)
Date: Mon, 3 Nov 2025 10:25:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, libaokun@huaweicloud.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	jack@suse.cz, yi.zhang@huawei.com, yangerkun@huawei.com,
	libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQh1EmVd8IPHK0Gh@tiehlicka>
References: <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org>
 <aQhf5LJJMlvT-rrE@tiehlicka>
 <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz>
X-Rspamd-Server: rspam01
X-Stat-Signature: pf4j6fxyaikxct8h7pc1k4qx4un8i7cp
X-Rspam-User: 
X-Rspamd-Queue-Id: C7A3F40004
X-HE-Tag: 1762161941-870597
X-HE-Meta: U2FsdGVkX1/aL/p7wDGUOrb31OYZH3tKDtaqh1P7skX/OFXL7YhIIta8tzhXFBI8fok56woUMBJlBuWqrtcJ8aM3Cxp+tpUSDg2tdaG1hkf2xzOMeBvVHgaOBZj01A1YHau5y7lUZghYDVq9rl0DNDdgfsd15LFuOiqI31g3/uj9OaQpcxdSqXzU6s2kx1VlaaOeWAOvJRSdf9J8xUccyNLz5I8zESivPYD8fUjv765hkqsNOifgppLbHXti+cvz1SfkYvh6wUabSKfDwMq7/aZ6rSm2FKP7cWoEXRlhO1klXFl0GBuSntc1OulKbf4Pcv6Zs5IDhYCnFgafUg95obZkamcFQx9LKZrUiqbTndWa9xIioRC1IJDg3dJxBRiM4zVANZujaw5l/KHIFWNAPtUTQ6q4UCYGge1q51w8OvOSA+DE325dVdEYWWKINAyAajfgPj6DBODOsLlS8b8+BIOFDI15GusJIaG61R/IKQIGu+uxS/ylD/Y8/pwzPSmA2uvYnOl5+IlrJkJ5E8+hs7jeZsfJk0dsZeginNO7lZpHiYsR0B4ntlZEvVK/SokROj8ZYmhA7hQlwe1npY/tJEI/W8TxUs5/QXMuOs+oycEN1+3YFd6kazw4lo3ruJvkLCpxKHxzCA7FRohJfcwknElGg4x5aHYu5oDRon3O7ZHajPJkqM9FWdApKgIXOxmiq0BAZaYBaLaE4PWGFwFRRPq309nBQpmZCvi9o9+iUv8rNEm8oobo3gum6VRqj/yVkfPUIp4oxQUl4GL4/h8Ct9i7p8i5J5RB3/1HaW2ZpeckdLb/oiIwxSAjKgy7SPrPDPMPAb6sFAoSlkg54IU6/f6sZa/tZ1uH/oxd5IKZb1XuoXwtGykTc2i/74ZX51quk8V3WOs0QPKn6/Wvhilekt7m3jTE82iMTaWcKnQ/wwOJv66X3I9mR+u32EkjUfW6I2YLkPYA2c5s2Fl+jbW
 X6x/TryE
 K3sWvAnV1qBH7rOjxC2GI854zwQ5qiPy7XROErme9Rbw8ctH3gtlgU0QLq2QfOdlc3WUFy+gQJr8bSH+oGJ9TKCoZUYOyFV20v5XOSXm4IG5B3cpKXnb8Fx1BR/rZXLYRzc0kTLMPzoiZZL4hqF2gLThm3y7DGmxKgLxoQdmMWMcR5XVAf/1i3lrB/AFKstOW2WUjFzrC8r0JFF5PQahM4PVm1//bmqyiz0y5L9/ehy1KXJE8UHSQ7Kmi9XYXXs0v7wNQqjexCmA/F4xJX1CXIEZPIVu+PGSK6oQg6G4AbH/Wi1gvsKfhCw/IAPjecrOVphyABMOZ7xqq6T1Wuo6JiWHCDbOe6FguoHa3CRiBImKT5t+r81oe83tqfpd9pfRKYy7GD5rW1IncP2lF2sVCR5a9Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 03-11-25 10:01:54, Vlastimil Babka wrote:
> Maybe we could keep the warning for >=PMD_ORDER as that would still mean
> someone made an error?

I am not sure TBH. For those large requests (anything that is costly
order) it is essentially a loop around allocator inside the allocator.
I would be really much more worried about order-3 which still triggers
the oom killer and could kill half of the system without much progress.
For oder-2 you at least have task_struct which spans 2 pages but I do
not think we have any guaranteed order-3 page for each task to guarantee
anything when killing those.
-- 
Michal Hocko
SUSE Labs

