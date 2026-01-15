Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3A1D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD1B6B00C0; Thu, 15 Jan 2026 13:17:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DB06B00C1; Thu, 15 Jan 2026 13:17:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98B96B00C2; Thu, 15 Jan 2026 13:17:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA1396B00C0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:17:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FA6B13AFB5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:17:50 +0000 (UTC)
X-FDA: 84335006700.15.622059E
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 85FB01A000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:17:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AJf+C6lI;
	spf=pass (imf19.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
	b=jlmc9RwxJeyg/7eyNfo+amAyFtVs/1baINOYu/Jhs3PXNrs/iiTK2OfUMzNp/a1a7bxKcd
	w9+VyQCqDf7Lw7BNvPENxhGMcB5e3pgg2X2WvcRd3DbL4wUfZU/gxhCXXx87sGiTxFd1ma
	PPsKrkodzLw7psXmau0VOh9IYQbGDO0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AJf+C6lI;
	spf=pass (imf19.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501068; a=rsa-sha256;
	cv=pass;
	b=kSWtf2tN3NRDT54/VGl04YcZsoQbVXEGnj9eA9QpF5sZ0MuazzuQDVeiShGt2WChQuDRyX
	0Of8pyOSv4ePLTtNu/RNQEZYxt+AnCLRaZw+HbT3bKRSkWjtSNOSmJNcQXTaNwyBWq+vXC
	VNPTBFriN/fr2HMjurL60hjNSli++HM=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b9230f564so1674496a12.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:17:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768501067; cv=none;
        d=google.com; s=arc-20240605;
        b=EP5yURyNJ7VRx45QGNZCqgLYD70wFMwqeib8QjV9mN2YykRctfw4XRO7mtNteQxweT
         nEYy+yK+BDMi5M/FvUpK+eBSoHOKWnR4tBmR/fw5AhiYsx7LeM4kwRtqRw/CNDfL0qtu
         GpMJHZkOeSNkfibmBjiAz9Dh2AV12i6P5yTtmZRKUBXGzo9zGR3xYmZhRl7XhYhI+S++
         W+G8F1ZelJiWJ6Y2MNIB99l+7rVyTmqWtNr/8ntbL5HZBHd+kHhnxX8WkvU6gxl3pOZK
         dykJJzym82CayLiHv2zJz11Kb8/RpNP+qyc9SeniHL+en/H31XujXGbVI9/KFXIym8+Q
         l8wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        fh=V30WEof1BWL4xRod+nxUQ+VXL6VY1uWAr4RBVTIVeQw=;
        b=KuYcovuQjGHQOp/RLf7OrZE1Uc229g6uW6AJlMwytfro1Er7zSH+UZEKcaIj+hbx3/
         PAraxDBKmP2WcFpYrh7xCYkyIm61t6c9cKEShzXjGosco+sUHxAbPvsbzVN1OKyF2jP7
         Y+NUEMscII8L3MHfHSSv7senk8lFhIQ6FYlK3t9Fay/FrYRNtHuk9HbtaJvbNlUVyCxW
         AMgY8xmJaZX+X0hnU91gg+ziiSIkgn6rSMo3U4YCJeXR7si24mj1oqB5Oh9GYKIMB/uV
         ZPCuu4MLssnFFdTEvJ+OBH2ZEk7QAJjmN2LrQt1WrA/sj7NKFXMeaUe7qfoRyAF3MRXR
         GjKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768501067; x=1769105867; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=AJf+C6lIUg7kJQM/+pWA6xwRa5bhN8hsGtLIGOIiMQs8uD/icqcv/6sOiNOxmxQFCh
         Ot2mwSWNBTomQYVN4hVbU+Yx9JWMmCImh/LaR35FaYfwCAzfkEZCx3OW2xCkUit6MMhD
         ZN7VuOnm6ZFVIiTvmyyrukg/qz2sGn8XH6QsuV0QhNEWIr05R2fiHSHeQXCaHpoJSurT
         rYpjPlPSN8EjVZU4V02OlTRU3HSe1xRETfVlRyeuIo93z5xNkIXli2tRg0NvxrP+Hw7S
         J2QPykfJoNSw0mUQn5q/lGTMKF5/GHQio3txCX46QNeWOFV48VryRC9PQ0/0mz7rhLjb
         NRkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501067; x=1769105867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=QpB2/DJzjzb58H6ZuLRiY7MwqGyN5+aZ7lwi3JPJ7/263w46ieF/hXVyyuuRvisPVu
         OfdLvyZVp7PLO2RVCL/Rqd3RxDIDpLr8dKYQGj0YmSYKrByUcC++fOYPi1mnbGsi6htR
         VDp17m7Zv2BhezfrZ4OPFmNMAjId2A5Ihswj69sox0Dj4Z76+TVC6AuUxbkDgtSqJtyF
         szOE0BP37BhxGPYTL+iCpXNqoX4KWp5t27YKYmxAfEJaQ20UyHDHXOHqwbkVuqKbkiCU
         MEjeQrTehIZZeNG5SFE6y8RQKY0C7YutOqD5ofXcqADFtnELCfa46qSIK3mnAwHap4CS
         BHLA==
X-Forwarded-Encrypted: i=1; AJvYcCXQIKvIVWjnChUuhqAiMi4BI5pmMr+1Er8ERVDnXaAkKWx1cDxeMVbaRdQmAjo+uy1QnoiOYjK1Bw==@kvack.org
X-Gm-Message-State: AOJu0Yz7t/Xb4MjYWUdhPY2CDhaDlPfCDEf7KnLkkrOIpxd/G/OYBtlF
	x1ddQVathe+uqWVrIEk/HYjrYfs2U6oYKFcls8gnYKBubSdLqiGDXXrwz475nlzgj20x55c+WPv
	BSg4ulhS60cUvYuVS859yUKffw5WtCl0=
X-Gm-Gg: AY/fxX6n4dvJFEFnepJzRDcPtyO1Fa6plSETHXOxE8UUPv3pb1F97tU0miBED9O5a8C
	/UEQZvSW/Jc3JOU2BgXncATjtYumJdctCtIh/VIz5aBCkJQv8nln4nNE9Chpup411D+cJZc62ZE
	WBva/+EKX8E3A9rMW2EuDRTV/UR+pBw8aly2YKt+9PF2Z4WiDLTF9d3l3FR62E02YBIzm5nZKLO
	VFbaUVetdJJMJq7vZ8hEaaocYf8eDOj0VzsqqVPxpvjv5ZY02RL31JWU5U6DLQ6AtIRpzDY9a1v
	/S8s68Zz0WVdP7gdxh8643I6v50xwg==
X-Received: by 2002:a05:6402:510f:b0:64b:7eba:39ed with SMTP id
 4fb4d7f45d1cf-654525ccad4mr346097a12.13.1768501066374; Thu, 15 Jan 2026
 10:17:46 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:17:35 +0100
X-Gm-Features: AZwV_QjhT3ZtgvkbHJB7796GEklGCbcNDL5CeRwrn_YYeN3X8FqPO-3_iRnRORw
Message-ID: <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 85FB01A000A
X-Stat-Signature: isotq5wytc6z93zqauncgs6rukokooom
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768501068-456785
X-HE-Meta: U2FsdGVkX19zySESBaKaFkUHFM5Ybpiy4jjK5n4NLdBXWPZsJal9T55QN9ltOdOem1rx9hR2YMHbXog2YuksUkKjETNEeKUztMke+FT4sy8zAL8sV5IYIk5AHRxvJaoYnGxweUgFN3bJ/8lgiX/l0pm14RqIPvGCXEthWkaRiKwXlT7PdskyiGZCoogBbjv0kYuRWTY/vry+697cgsPjaplllP0oURbW8sOd6xspWLoOf5Xwdz2EauDegxcthV1002+tvjLntwQUrOZlqblVhw6H+mhxjKOc3ziHels6vXgotexkflUuG0OSbpq5XufEhlfiprv8dr0XytxfmcjkzvQyVFo54ulpMh9UXeymfkH+y901+tbbCpmElUMp1FgF22eV3kI3Q8SJqtOfQZJO2gOrYoJZwnp/QB0Jh87sCVnvmZcebxVP6RQeLd+KRh1ZwZiY0Jsd87046c+VOz9AJzq7YeVvVRfpt+wS4KTPPzXlV+YlglIaRKNOIg6YgSasl/tlHLhJ4RS5P9M+e19E8mqIqvmepjY5qqat0yOXGjLOg4g60AikOWDE5Khb92d/tEziWhudafbhLRwfpyTyPXGELQ/gKeEwC+0e/qYoKa59FmxkXcYlwvOdQQVa9V7Z35N4d36MLFPNIiYzPEbnKO4nIP5F5AxZNMcGCqKQ2MwUqNRtta/nxlqZiAZ1iyDdVIplWliaGS2dmk+Qt28cvlnAmDoKXgrZeakuSxtM4tinaiMITArdAXclZQph5dxnYBG2crHEBMnGxTutOIeu9ZqgAM/pz+VJmX7V/CxDadfOCB90kzSnh6HwDiNBV2KPvRhC63vrD9DtybgjyiTe3SJL5GAw3WoLrzg3osCYLGsBOXIOOEGzDOp/jp/hAE9qANFQ6kdx95dATph5f3MR2hnno4o+Ta7NB7W8W/JI0G0WA+uyALOUkltxYKbKYVsV8VhIg39CwSxVuc2gwBt
 J3oIquES
 CQfk7jRmmLy4LPzacVvN9KkH4LJDrmCxieAhlL3/widioeQJlovqDBvgbQ7GwvZYHWcb1BJOkc17UYsN6wT2WGgtm8q32LG5yC1dMxYq9NVkXmI0GbCzboKxF+68AOLCO7Q7Q1/tSZN7mWGsbRp6CSKlv0/cCbWBHhpIydRE1NOiy3PTKkStdUWqzygKW0UopS/Y9zvLh6iVSWroLkQs/YyM5GnEo6bo5E8e6EOdk5TSKFb8hTl2HOrIShBX2gpZwFU3vCLS31KhtV26Arg6Z3YkhLK9aLU+ORD8npdLQ7RCoZ70EAa36oIJTMahawcoJ1ugxy14XBPSHuZPrVhBtYmyUwJUa7UEbwnAsXX+KbhHd+5ofxVao0OZzdtJS3ep+iGVt9M7Nu9VIlnu/T0aCUyuxBPz/xOjAEeTSzi1XxOErbN/Rge9/23mgPtRzOQRBJ1B8KYHOqET9S00PhoMWC7BhEDEfVyr5xT7MVZ9Skn36Lqc7SfoitFU5CD/4ieTYX+iYS1zCz/I3u/BuyP+5zRo/B7gA9Fu2xfRK1HmqAWx9+zXtB6xWEGW0KMLaTdJvTY9Se3f8luHoGEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> In recent years, a number of filesystems that can't present stable
> filehandles have grown struct export_operations. They've mostly done
> this for local use-cases (enabling open_by_handle_at() and the like).
> Unfortunately, having export_operations is generally sufficient to make
> a filesystem be considered exportable via nfsd, but that requires that
> the server present stable filehandles.

Where does the term "stable file handles" come from? and what does it mean?
Why not "persistent handles", which is described in NFS and SMB specs?

Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
by both Christoph and Christian:

https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93c0=
0c@brauner/

Am I missing anything?

Thanks,
Amir.

