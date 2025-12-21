Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D4CD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DB86B0093; Sun, 21 Dec 2025 04:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1AD66B0098; Sun, 21 Dec 2025 04:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4086B009B; Sun, 21 Dec 2025 04:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C22A6B0093
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:44:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33CE2136579
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:44:42 +0000 (UTC)
X-FDA: 84242993604.29.0AA0559
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00EB7140003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:44:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XnoS3dln;
	spf=pass (imf23.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766310280; a=rsa-sha256;
	cv=none;
	b=zem6e3PJ6xzmSs251B99ctLa2dW8z+51XEG6T23kscYtwKWNfP71GHIgEnL3E17NZZ5FQX
	dofq5kiW0GQOMgtag6EhT+phArRy01lQj3+iuiZHDH5G/RP4vVMRt7t0iP5bbBbH1nboPH
	O/TgQ8fl7ZGmWkJUROfdIwA8yY6cKFM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XnoS3dln;
	spf=pass (imf23.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766310280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6+y9WLSDsSxJtOaxUSqUViYU4g6HBpwAKq4mBGcgzo=;
	b=Bytv8rUhjkzx/7zcfLMzCihTjiDXG3SA8wn/0Ax2+AjBB6kttsjLYZnCcWpJ01kO+eUWJk
	hdRRp2dTAATNlkGKRyOP8Ubg0NcCGTiRYw3P3qQlsXqvbrcysc+VT5jTdLi9VUojVQ/+ak
	agzdQIm1eS5dpiki8rz8YCb7VqWU94o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766310278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v6+y9WLSDsSxJtOaxUSqUViYU4g6HBpwAKq4mBGcgzo=;
	b=XnoS3dlnICskQQMvBsdqG8zjKIK6on+mIh93vcOxt39s5MFZVs9p6eZSUOzSd+cG7/CNsX
	OTfVnTeBdrMCboJFENsjNJq72J4N93P2lhESFSXSYbGjfTqrBDVD4aIDX7IqRGikxufh7D
	yj3osGcPWrRuNeV7EB2k2gJy8Q3iRbk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-dE7pJANgO8C9aS9oObLjQw-1; Sun, 21 Dec 2025 04:44:36 -0500
X-MC-Unique: dE7pJANgO8C9aS9oObLjQw-1
X-Mimecast-MFC-AGG-ID: dE7pJANgO8C9aS9oObLjQw_1766310275
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b99d6bd6cc9so6320048a12.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 01:44:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766310275; x=1766915075;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6+y9WLSDsSxJtOaxUSqUViYU4g6HBpwAKq4mBGcgzo=;
        b=bbJAlySyGjVW7+x1R53rcoDX9uUyd8+/yU8SSNXcBJHwGECJ3aGZiJmdLjve3PeMwr
         COoXF3IGxaS1CHPGxXkSWtny7TZ2RexImS8te8CNVybGP3+mpyD8gXOyUr01spYYYHW0
         1WWBRfunpztoI8f5FIE1qzRNpGH/1SVY0nuk5fVSmjMa6QgnVp/JPmCEZUrLuUw891as
         M03zYxW/PoZtp8e2/FgTfL/OgmVnkcNRaF9A8ePfaee32P4I56/jAgghl4iv4fWGWU0F
         r7XuNI+AO7K2iQutQfM4IDAKWEHtIz+wnKbaTpb5Tqnq4SJNT/x5bJgfvWL6pxsbDcAY
         i8Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXUyW7TNc30x3DAiWD9jI+7wgHfcYNnEMUYJeqfD56R7hGMfud3t2fx+jmKf2GSTWst8xcl7JVatQ==@kvack.org
X-Gm-Message-State: AOJu0YyTMkpB3vLvOGvwFoWtAN/e10tOpGGtwYFwdo8uyn4YiOFw9CGa
	OLbi8d79EL48RiE0b8LSrU61fOiwLldyLzj5QwMtRn5eSuOyXYNL8soSrjDMk0k4gbJjLQdbt0C
	R+3q2dwn/7oirdDb2zzDnxluFwnbYFgKG2wuv9CQVcf74Ibh0Rc/OwecmX4gdC6/OiiK0f6SYnn
	DfgO+X+P+rYpMDorFGyEYYy2hiRq4=
X-Gm-Gg: AY/fxX4DKxAzzHYABcAUTThkN+tfkEUFfBD6gIbxfPxlPSiIPgpJNzo5vqW5i0GvtHN
	67cdqN6EYvwKxghHNpGVPvp0qmzImmDYciWCMjQqJsRzaPIoc/+m9fOZ/K/0Wdx4rXqKxOCcYkI
	3GJDgLr6JL1Y4/+S9hENUI1FDYGuhkd5tAKnf4cpgM3Z6exsQiyzo5rTjaqdj+ts2+tn4=
X-Received: by 2002:a05:7300:cf92:b0:2a4:61a1:c0d5 with SMTP id 5a478bee46e88-2b05ec97dc9mr9020800eec.36.1766310275294;
        Sun, 21 Dec 2025 01:44:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGL1i6p8N2hSuUv+xL5rM61Q5+a8Vkv7Ev7XAzGkSrg7/P90k3Cd5PYS0PYFknoNJAdnKhv9+PtZSswlmQYASE=
X-Received: by 2002:a05:7300:cf92:b0:2a4:61a1:c0d5 with SMTP id
 5a478bee46e88-2b05ec97dc9mr9020789eec.36.1766310274957; Sun, 21 Dec 2025
 01:44:34 -0800 (PST)
MIME-Version: 1.0
References: <20251221085810.3163919-1-liwang@redhat.com> <20251221085810.3163919-4-liwang@redhat.com>
 <970fa015-9ec8-4903-8e2f-f3e847d550d1@kernel.org>
In-Reply-To: <970fa015-9ec8-4903-8e2f-f3e847d550d1@kernel.org>
From: Li Wang <liwang@redhat.com>
Date: Sun, 21 Dec 2025 17:44:22 +0800
X-Gm-Features: AQt7F2pHfdiMRMRnZKTZtwZEUfCrHUSow0ksQmNv49Fll4mVQHzB9tXkUYQfG5U
Message-ID: <CAEemH2f67p=wqGrwYnoVCP1fR82xxwJv1xfbMmFrvNaP7LZJog@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] selftests/mm/charge_reserved_hugetlb: fix
 hugetlbfs mount size for large hugepages
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o-mQsVky4YFjNKCPbXKOMLwWiGDR290NiWkmG17BWLw_1766310275
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 00EB7140003
X-Rspamd-Server: rspam04
X-Stat-Signature: 4uqmpuub8bzniakrdo1647581987dbn7
X-HE-Tag: 1766310278-797846
X-HE-Meta: U2FsdGVkX19r59zEEg2C6PG5RnL2sT83fixpemOJnm8mirbj9bLbA31lxOCkuruQdrpydBhezzwqgKu9k3WO0o8Mx6eJ4Zx9CnaPXYq0MhXGzJsQPn8P2aMokNg92lg/0+4BOqs5ISZkMzIItNJ64N3ludplvEqGc2UN4Znuu7++x+tXfQ10PP2BpYw0HKMRIx4tTKtCcpXsUS+1huDd2ICxc2XDAfp0Czm4B3rH6qpOVBjvsBrA9oYuO9II0oyGIvAyuoZphdy7II8x+88L3ArMk+xcq/mGpG53aRmMh+rQWQw6QUmu1coNh1IrtfokuK1MKy1nlDAr+C2xNnBdNXNAT5x0xk8WBPzTMfNtzKtyL43xpDltrDbuz+tKrCytGKvbOriv1bz02rFyGtgvadB+iJvN0B6Ql2fLQXMk69HGluOp3w9DzbDZX2ak6rvLAzcW0g3a9C7wq/NeFwmVCyLPaNG7fzOUf4kb/HdNqx/OVrFFLaHWWGB4OsxL3zcKdtjFJXda50pwnYi1v4jPzorKkp639Dk1lc207LC6S/DNDcYU1Q1rCeqMZif537o53AOxkElYLAbpqnXDujXfaMgXNbFyFXVy2c0lAoRUWL2vnBH54ERD9ZErdxtKFo/Cu9WDdkuQ2XHu//of/dltP6LOGP5P6XpuCvKDFC+ViWTdlkBEXUjdKxnvNo8RJGftjNJ62dGhtz6qxLK/+fEcO1ZTKT/7U5icdm4lxKPBUF7f1w5cutYchkxYXKs7/cqiQPdnFtbdVnZXpxBdB4YEfQDZ2L6DIyM9yrvXDa19IRu5zJt3HVqWsPe8aPbju9WdorK3KSYm7AlfgOH+d505P5YOB1VfuOE5J87S/fQ4q6GZxjpr1Y56pIQH4t/k1nyCZZg7dsY+VTeb+xVq2hMtVF3D5OwerW27kD9BYV/+7cgUDnB4edGqHE/8fyNz+uz9o+y+fUrcbCupkBmbmZ0
 PLFAB9GP
 D9Fw0HXUlnRAeWb7QD7fFig3BkFnajQ8K4r5i/igLS3gBfhcE2jAFG5qJnVfAuCzIEmMpsEl9LXYhGYaakepk622/eoTKfVgQnddBiQBnY79/VpsP49HTdf7+BlnD3ERMw244rWfdm0YwTdsDjd6ez2Fgi/AXGRA08+nBP2Jdq0dqLnEQCDfHH/dgCY8scLclA6qjV5Mjec0g6m25gqBqQaSBwDtH1FEKpTDkLlHQgHCXnY30xMhKGQNP0k0h+5BjLVmpJIxXowRV/gfLF7GptG6vASkk5dO0tEAB4/C7UuSf3R8pvjzZlepqTnNpdWOCmGNpezMk8Oa2OIEs2sFuYiRIld9r1H2hDF/XVQjUGfb4ECyuzrz3mV9iwGvIrJyxscObazeBPrgY3VjRQKavqwjneVif3xKnkjqakdsHCNNTrOtWpFgwPSZVhqX1UShD3r+NGu4SQgM7pg1wV4iZRvy838pR8qDVq4NL2cbOPZ9t1RGT7CZ7ZdAgtah1lRow7cXy9QXIHjlfGmuA70to8sB5hUg8RKmegZNHisImvrd8jhTeXn4lp48MKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Red Hat) <david@kernel.org> wrote:
> On 12/21/25 09:58, Li Wang wrote:
> > charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge with
> > a fixed size of 256M. On systems with large base hugepages (e.g. 512MB),
> > this is smaller than a single hugepage, so the hugetlbfs mount ends up
> > with effectively zero capacity (often visible as size=0 in mount output).
> >
> > As a result, write_to_hugetlbfs fails with ENOMEM and the test can hang
> > waiting for progress.
>
> I'm curious, what's the history of using "256MB" in the first place (or
> specifying any size?).

Seems the script initializes it with "256MB" from:

commit 29750f71a9b4cfae57cdddfbd8ca287eddca5503
Author: Mina Almasry <almasrymina@google.com>
Date:   Wed Apr 1 21:11:38 2020 -0700

    hugetlb_cgroup: add hugetlb_cgroup reservation tests


-- 
Regards,
Li Wang


