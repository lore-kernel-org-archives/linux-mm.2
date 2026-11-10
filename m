Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408C6606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cQb/AnvP
Received: by kanga.kvack.org (Postfix)
	id 63F896B05B9; Tue, 10 Nov 2026 17:55:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6161E6B05BA; Tue, 10 Nov 2026 17:55:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE6F6B05BB; Tue, 10 Nov 2026 17:55:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2337F6B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:55:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEC5C16017F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:55:04 +0000 (UTC)
X-FDA: 85420716528.28.1852585
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7343D20006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:55:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="cQb/AnvP";
	spf=pass (imf03.hostedemail.com: domain of wqu@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351302;
	b=lQPVrNtQ1pV0nGs9y/xCptndgwvHiudJtV7qYCSMFSOQaILuBnUjxiOHkh3fOd3WxrDhci
	VPTP+oyOjRQ3/3kLLoPy6FTtIEPT0+xchvHbhy9OBSeEScH2N1mOewdj3L6VqyGdUrpSid
	4A49r5/C76/vU+Sji3jgC4E5oBw/soA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="cQb/AnvP";
	spf=pass (imf03.hostedemail.com: domain of wqu@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
	b=F/mm21lb9XJ0N3I8F+WTgxI61aXoVZVc1rDSn4Ckvr4xaLUFmggIC1kdFdlnsY7lukvDgP
	Z6v96tFZJOZdk7GMLVrTmSXKX5h6tly8ZYlCBKdvVJ4TEwPE5XWOFshF3yZnSCSv7nnk+6
	iuPsZlCu3ldC/7C9YpxucwSkOgQZILM=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4b467581b98so24257115e9.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794351301; x=1794956101; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
        b=cQb/AnvPDhQySfX3i/xPoHJVGSsiiPx7SM+DYh2y6Lv/aBNT5S8hdQ7k+/VCV5FpQE
         whULn4s/jnPaTC4S72dLEVDTK8cb9tDya2sMd4i+UWLn7p1JeewzGg05Yx/Z5O79e97n
         7qLxvDMX+PPsUOx/xiVHC32eQy+xv6X6/LP9Hc5WRPdXGDDiXH68Q7ob0LDRu6iAMzHb
         GsUYYpogF5055EAg4f9ftzB3HnoayMZh1dMrFGyePnT7IWXgfvqPT5DgbgUg9bhnR801
         6+67L1CVQwiZqfaB3qt7J2iAGELi7mv8yH5FHHvBT/C0yvzVRxYjYd7x8CN+Q6ICPu2e
         uThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794351301; x=1794956101;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
        b=eXnx+D6ujsnetrjPcH4U/vE/EQWXxYUMYh8bwO/T22gclkRgHrFpIWYfUVcITWTyD2
         eCCe3xW5prGtNq8W65GzHcQjt/By9b/Z7UD6W6Pb3uFTNKwI4hoENbZYXTSlmtiMdci8
         AsMLlPmXkGpnGsyvcq3QDvHTt/YUDWS/1vjAjEoGGV5iPenQmSKq/CKoSQJDll5i59qb
         A4eNue0fcL7KIBXrJWJ/DZbx6Vlel1AkMEGLaJPZ+z/0VDqnt2HG0anuuXry4/ZxICjW
         K6Y2J7+Uh6WJUJCNQbTL9FoQi9Y3eGrtK0DZi/gXD6RIdvO5Q8SU+9rms9qSSIznqLHs
         80rQ==
X-Forwarded-Encrypted: i=1; AL+hErEHfeJ5nPyD9OdqVRZIzzFodQ+RTWfpApC9qupwI/bcD0EpaFhqecEjOY8NRvmo4q8plLt6ZQZhXg==@kvack.org
X-Gm-Message-State: APuU4Z+DeHQcW6acIM1DTnb8CaNSAKwqPguAfCPAOK9xuK5ENSnxJ3EO
	j7q9dlM3owBnDMI56m8h9zi/GHDf6qktNwy3P+fohAxbrN9tvFLkxJqRcODWS8XBndc=
X-Gm-Gg: AYBFou20tGaBYrf2F7V8yNv87CwGocpbBxlwaMAA3DEgPRXRCzO8ivaJ1Wd6IOxuukn
	abNYiQdfA9yiT3fagGW3MeGLy3t1vklcRII7wSYLnVJEgmMBw3EIqrVY5pgrsLgUZAIQx3MsycB
	z6gXM6BptfF2pphmXDLATcP1NAAlLhCBJqTMTeShlCLTW1mOQzxu9DTP+UjQXZsdq/3aMFs316c
	p2viSdvcer5dtelDZHJq4oQwp7J7ObVHbws0sIG4f3qJvWqDPU24T5ZGi4bWw1Xr830E/B+TaCG
	HrD5qG7ujYuY1tL7mk1gjSXwM2nNrrg2wsiY72PxHX3kjnSqcW2Rhz6MD6d1G8jBgjFgfKpyU5x
	gEZvxNEXHJ3AoVjudg7sWaivyGQabmGg1dBTGfjYmvwLiFd67YVZqnCEMoyriSeJt4eZkvWMLos
	KAx5br1FNx7EV0WYaFK3EXIJfTD875lBWr3gb0an8ZbNBkw8W98qGGqU2B/Lkxs3h5cQwD49m7a
	xa2wxS0Ll2QRtvfWf53RXwmV0pJX2xjO4ah/50XTFcEQvP11FXO7bmkr/2nLK1bscRSPezeQ94m
	hRBtmmY2hqOwhWAp8iDjfQ==
X-Received: by 2002:a05:600c:3c87:b0:4b8:fdd8:f2c9 with SMTP id 5b1f17b1804b1-4ba093c1c0bmr7546615e9.35.1794351300895;
        Tue, 10 Nov 2026 14:55:00 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaae3e582sm1412409b3a.39.2026.11.10.14.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 14:54:59 -0800 (PST)
Message-ID: <c5c47eed-c927-4ee5-9841-7631674bf6a8@suse.com>
Date: Wed, 11 Nov 2026 09:24:52 +1030
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/34] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org,
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
 <c88e4e9c-6b86-4fbb-94bf-909522badf83@suse.com>
 <20261110-kursniveau-zeltlager-quintessenz-36b26debabe3@brauner>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261110-kursniveau-zeltlager-quintessenz-36b26debabe3@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ixzcipd49y1h6qfb9hik1kzkuxje3zhy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7343D20006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794351302-288854
X-HE-Meta: U2FsdGVkX196++SaktaR9thKvddRSCGSTYk2raPaeV29TFR8cwMPwUVYzpZaRoUWW/ZjmImBqcBGhER0QAQRtFG2a/lIkC0tiOUEuHiqQ1doxWbB7/rdX2LAfqfSaj2r/lRtrfhbQ+p0M13zb12ct4zwldhJWqk6N96EHfJDLT7yXj35lfAjEtpqIq73WpLdFteR74C3xm+V5JBLuVMEW/+Eg+wJ2xkvNDJWueJT0cvIIImRh0Hp0Ynncz2tM+kjAje+8wusTrIAXRTfxgXpwNk/QzsBFO0INNLBlzsuzVyyGhz0fCX+Bj2UY4ny0DwnGDFvuXE3N+pmrOKx7Bq7/9AVTYI/PaGamVsmu/+P6DwOx7Dq7VdSYNPq9zPvcvkj9ey9AcPd7Mt9trJfTPJ7cE/ZkP0Z1ZqrSdQiREhP2IO0J7JclP4N4wuXCLIPUjRFBrmJMrmqNw3r8D24d/K5h88Z62eHWCfJ+vFeWd3+fYZo0SFUKEu9Q8JNgcja10tloJEbMYJ+jBCMZrAaQRT0ej/9SgloVacZw//ZYeUiMNKB9KeXfFZBHvnKAmTEeBBtc7Uk6K8x/9wpSAsDT3mesy8a3q2HTcsPsjWzTCoKculWV8aWcnCzImUrclrV76VWrkONXgi2TDe02z28pRRAafrSmV3/O1XFnlMjpr0Mx9c8r2YAjKVqOoaS38rTmbMN5VLGziHXzToYthFLObbO5+Wpgn93fzvEf1YQ821/CedjM0qJOWLdR+lKzjMeiYZMH0DcczCm06GaZBos1vI+10B6tfzmI4NVJouRiPO+U2sugSfqDPM1RUvKPpuoHNaOZYXPMqLaRsMmZjqzqimT6dKOyjlRvvqOuZfB1CnGBODhm26UIJnRYfd+rbYg2D2lfPZj+eQhNnBmlVbum4Ee/99BYCaeJK8Pw7pCCdpAklZF815SW/mQpiB/7byHYk8Pn/RkHWbYF2Da1tAyPv3
 A4wU9/1W
 FWzonh2XD6wc9V8FTg6d16QVqAS3no5XUsBurMV/wPmGgpAD0uAee4DX6N+zcwQPvauY+zG9fLdvUm9AHYn2m6cxWjdzTZsUD+35mmHDboftOGuUuVXv1cJ1jjLOWjAh5DgGapuFaGVlqKuXT1oCI3N9ZDw6iVsa49+UMNtLsoGlWgqo91KJH4ZdoGAt2XyL3z5VtsClPRXFDKl9umCTvFddzvc7b3DvcWQjvLP7jPmY12F9e/g3Q7SeG1hKTH1c8BOMFmk62Jqev8oDUME+x0GCIpgbrUeHPDn4Qvvyb6ze3AEisPhoDkAHCBDDKHUpNEaYqACtkylWBDL4lkOPuY7VBPMnLXML2wyY84L2fFkLN9k12EcbWZXNUW0B4UX1fy/bjkaMp193VN4zkhqOa2eVmFW1d9C+Mcl8T7yXMxImkWG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/11/11 08:24, Christian Brauner 写道:
> On Sun, Nov 01, 2026 at 01:26:22PM +1030, Qu Wenruo wrote:
>> I love the idea. This reminds me exactly why for btrfs_force_shutdown(),
>> we have to manually set the fs error without marking the fs RO, to avoid
>> exactly the same problem.
>>
>> With that said, can you also a set_bit() call in btrfs_force_shutdown()
>> to also set that flag instead of the exsting setting fs_info->fs_error?
> 
> I think so. I'd set BTRFS_FS_STATE_RO in addition to fs_error though.
> start_transaction(), join_transaction() and btrfs_remount_rw() key off
> BTRFS_FS_ERROR().
> 
> Note that this changes some error codes after a shutdown.
> btrfs_permission() returns EROFS for MAY_WRITE once btrfs_fs_rdonly() is
> true so opening a file for writing fails with EROFS instead of the EIO
> from btrfs_file_open().

That should be fine. A lot of other call sites also return EROFS instead 
of EIO on a fs with aborted transaction.

And I think for fs shut down, EROFS or EIO is really the last time end 
users should care.

Thanks,
Qu


