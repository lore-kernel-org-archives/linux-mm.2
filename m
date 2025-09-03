Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AC4CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 21:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141288E0008; Wed,  3 Sep 2025 17:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F22E8E0001; Wed,  3 Sep 2025 17:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBE48E0008; Wed,  3 Sep 2025 17:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D84988E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:26:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 834E3868C2
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:26:26 +0000 (UTC)
X-FDA: 83849222772.01.9B9648E
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3885520004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:26:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=enbusPC+;
	spf=pass (imf03.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756934784; a=rsa-sha256;
	cv=none;
	b=cTVUd7TGum4M1jcMUmyXOt6rD93eJReEI4d5Rnbp81cqpYWc44/USxy5Q07LMlAwae2Sy6
	AtXnU8yiHHHPbCvqKZRRnDrpLWtIRg2m2O0e1W53gR+ReqRyjWo2C1CGpCHEj+dybX9BIV
	0y7cQulNFljctWM3Kh5WvyKDybWD524=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=enbusPC+;
	spf=pass (imf03.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756934784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZKAFUEHK8OBYchmycuUbisd/bzFy1QHMzYkOvBvFOpA=;
	b=oS1D5sSy4QhgTdso9IK4682AG5VcEUSRPDEs9Im1I/nEKwBzDVJUL1hM+YwncNi4isQ4Z/
	Crc3h3KvTejeaRIiw89RaeB7lZxuN+Or9WqwdkFGaolTOxTwJ8bqHZpnax97kkOO6T3tW0
	iR6jRgph64OY3YBbda+ZIav0cv/JNLY=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-720f0dd2809so1736636d6.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 14:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1756934783; x=1757539583; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZKAFUEHK8OBYchmycuUbisd/bzFy1QHMzYkOvBvFOpA=;
        b=enbusPC+mwfL2PtullM/LFFzOXVa/pviQ7/V61Y8IqPWW7ddoNGcc14nyrAOIyDCvF
         up6JF4uqf3nDGtUz2EGluykjrO4pKJDav14wH1EHDMwWw9lbulzAGIO3vJaBbNY6BCuo
         paCkKJqzcpqhFJCQptT01AtSCO8yBWAtKj4086JKv/qyEF0uu/c5cglSuQx7xlZIM80W
         Al/UwckR4HVM/f4YnD7uQbXqLLcI0gkwfSN9Ui0S90HHOZtZVoWSwUvAsKRFGNKCkNzk
         dTTujPH+8To9j8uBZYhgoyhPEXT6k8T8ZdqOeo6OVcvR47tPns5mVOpnFJF15Nuzj2mN
         Sy8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756934783; x=1757539583;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZKAFUEHK8OBYchmycuUbisd/bzFy1QHMzYkOvBvFOpA=;
        b=bIayUWN1z8Jsmp3MyLL20F6AOlr9G34XhRLcroo/GPI+bRxxHJQiUhjnwSlvsdO4Lc
         YWJmkG/CczQNJ1Q2t8A5t4bK/Ebdq8hBRP5cqrr/aaH5DtZjDNBVMGEleJoaVGWnnATo
         PJuh79gZAP2MLcwK9rv05t8rhwFx/wil5OfpkO+YBGSoCFOsrAFsl0oSGR6z3BEHQmup
         Hl0q4vLd8KLOFORLyaqDijHuReUsgudh0kr8Q4Mwe3DgDXUWr3P8uTs/B4BvyrobC+Nl
         C+V0nwy5DBf3BPWXquaoLD9Cv6vt06IIVpjxgUldS5W4ZvpOzthbICUHqG3owMX7en9X
         jfoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUAN+40Z9teMEgZrNKhPv6PdvXcbWGN840h+UpqT6vawMTk6DESW6D1v3S0PIpEMLraZEd9U6a5w==@kvack.org
X-Gm-Message-State: AOJu0YwzLD25x7P2YD+u8kBH7K4LdLovFP9284KNaNosNJNWNlGEjEcQ
	spUMyMencxDJJobJ39pIUkLl70ZhtOwmwSwV6G7OffnkHLG9xVcpTBgBv4goCrTYwQ==
X-Gm-Gg: ASbGncuDDBIapTbzkYqvSkd39vyRUGzOdScRz+u1EUKL9oeCKaGA+Bo6m8uOr7KdVMb
	+XdPcrpRakQiFb2EqRbIWtQBx1KataFq9RMARQfu2I8zjXSzX+4zHUaA+rZj0JWt0EJs95Vh3CJ
	G25GzvUywhpLQJiflFyyxl13yoRk4dIDzSy30VTyBD9ggecjppMytFoi6S7qF2biK4zOlX7/SCD
	Zkl7RanVCFBGVgJYdE44XxNPj1qS8OeKv1sJjsgoFfftO883P8JMVrsKhqivFEG6Vq22uksXXf6
	HTXgcrhqMlgpGUktywJwqAfpaYyqfIkR7Uv/adWDEwwM5zaVOKOWTokP+EI7fRJXG/v8ViQFp5N
	/AaUplU1b3XcCH5wvX3sVaxEdPx1upv/3Jpk8GCKEcquY7LBLgGTZ0ZZBRWe9vsu6RUR7LnQ5eI
	C54h0=
X-Google-Smtp-Source: AGHT+IGjeGVBk59qanrKojqKe1+ebv5QbBLUr+xq2vrJdB1gpx6C81S9JV5wN46o/dcj2HWmCycKCg==
X-Received: by 2002:a05:6214:c65:b0:71d:478f:e0cd with SMTP id 6a1803df08f44-71d478fe49fmr118773496d6.26.1756934782933;
        Wed, 03 Sep 2025 14:26:22 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-720b466614bsm34702456d6.38.2025.09.03.14.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 14:26:21 -0700 (PDT)
Date: Wed, 03 Sep 2025 17:26:21 -0400
Message-ID: <6afc91a9f5caef96b2ca335b6d143670@paul-moore.com>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20250903_1645/pstg-lib:20250903_1606/pstg-pwork:20250903_1645
From: Paul Moore <paul@paul-moore.com>
To: "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com>, James Morris <jmorris@namei.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
References: <20250826031824.1227551-1-tweek@google.com>
In-Reply-To: <20250826031824.1227551-1-tweek@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3885520004
X-Stat-Signature: nky5mafyh1761kmqt6t65xkq8qrxqyj8
X-Rspam-User: 
X-HE-Tag: 1756934784-657137
X-HE-Meta: U2FsdGVkX1+HrlrflgFp0B3HCQIVeUMCap4iShEDaRj4rIB+WWz5EUG0GPt5w7Me7h+yqtWYxSvO3Sv2Fn9EhubILgLohe0biFo2MQKRCvYZhP98U4yIJyd+JICaFD7XanqhcFEdYAp5gpFyQHU/jyVisdA9VXrc0PoNq0znAnXwpiMqH+n9KQAkt+td/Ibpjad6RubYZEvbSoHKWvnJ4k+9jiFp5MQjR9i2re2LE5JtGpUj7duFLub/bXvHGWVyG79r5bnUdhjF5FGFcOghUXiePAYzOwGPgdOCyKjaUDytP0SQzw3z9Q/5gWNk0LYCJ9xnz5X9BhUMDbciSoCOnxirKqpbz7AF9cmJbelM0m99H71wHb5iKMHMlP+mJczVvhMfdASk//QnJHU4DbnM2+cc2N/w6TP/uaMcby7+SEtFWuPCmfMz1k9izKO0GgHrNmwvAt7ayArglQ5qs7C075wzRa1hPB6QtSVUR6LESwiASNpTGTduFDslfSYUOfMaTNnFLXQrkWwkaDzgZ7cjaYa2rE7HdHVbneBXJbKDxzP/tcGn5Jt2WnoopUC7oKgj4pROCBtJU1zFfkAvEUisl/gXixkCJjAK1zQIA3pTi6ggROV1IAZ+6YdwgZ3L0+wIRAmmHVpxZ6Bd8FDhS9ZC8WwI5OYsqL9K5icdOj+uJZhWBASr2S+ubdhs2iB0dqMs+gyOtlKcKp30gm/yBTezXdGu+DZlAIoDD17XMAF+ioqFARctWi5+GpCTQLIaytI8ZGHmRP1VSp12Au9xE9xjxpHu4/PkE69nqkMRLR7JCx5m6BqEqzGgMbec+3FgJZ6Ki+ArD7NOEAaAUYffWbw21p2V31U/reqUlAp4/IBvA8V0AaUY1aaJiUMp0GB9zJs3mea/+Cq8/k9eiSfAA9yA05/3yk4HPDmnu9l0dOvLaB4Q3YPwNihF+NSrPOs9d3UKCd+rDxIWHvdT9UrnHbo
 ULt6vksX
 xkYhzmLQil5NeDeckbbuVEcTJdwjQB0fqgj6rrZLYYl+D5XpZr2JPKGJIx/omESguO6jLX1vv7PDPo4OoKdS9rzEsRvO+sVkG0BtRxhlN+ltQqTGDP5WwZaDUPkbm4kAI1o+QUUzWh6pBAsoupFqLUu/CYJ8mJdJhIUHD1L1ePAfqKmUy/irFzvmKaT8Zc88uZOkIZS2CwqbZ/oVir39iJKEwVlLSG98n1uzFKmbVim0NseD8S1cCptMTbQ8rVUswTuMf/PuYTIgrf4EWktvYtSbVh/0oG6eKkI/zkncZYVsrohY4pxUYUcI0kckXupxBvpu0Y2ifF2d0Yc8WA0oNJAwIVAsXxgsAqVqK8hLnHUTW8hv1lAD3tTkk1tnZrUt4I61it8lX4o1FZMy0hZ8iW1smUSu488Sf7yD8wKx8VTZEUX64PZW/LOWqy6Mx5yMAVoAbTew+9rwZnWQEWuQdJCVJNw6eBIQqpa9bFNJZmtwty1vQ65nkqqRUuaEV2D4Xo38dGMZYKzXamT8j8Hx+4fMRjju1/D5yWBtSKjpfadA7QZ/vpTrxipojS8FJk5rFTr+AmJPeKtLNcms6nipMww6CT+pX58lreYrsSOfxBRxt2Xc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Aug 25, 2025 "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com> wrote:
> 
> Prior to this change, no security hooks were called at the creation of a
> memfd file. It means that, for SELinux as an example, it will receive
> the default type of the filesystem that backs the in-memory inode. In
> most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> be hugetlbfs. Both can be considered implementation details of memfd.
> 
> It also means that it is not possible to differentiate between a file
> coming from memfd_create and a file coming from a standard tmpfs mount
> point.
> 
> Additionally, no permission is validated at creation, which differs from
> the similar memfd_secret syscall.
> 
> Call security_inode_init_security_anon during creation. This ensures
> that the file is setup similarly to other anonymous inodes. On SELinux,
> it means that the file will receive the security context of its task.
> 
> The ability to limit fexecve on memfd has been of interest to avoid
> potential pitfalls where /proc/self/exe or similar would be executed
> [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> similarly to the file class. These access vectors may not make sense for
> the existing "anon_inode" class. Therefore, define and assign a new
> class "memfd_file" to support such access vectors.
> 
> Guard these changes behind a new policy capability named "memfd_class".
> 
> [1] https://crbug.com/1305267
> [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.com/
> 
> Signed-off-by: Thiébaud Weksteen <tweek@google.com>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> ---
> Changes since RFC:
> - Remove enum argument, simply compare the anon inode name
> - Introduce a policy capability for compatility
> - Add validation of class in selinux_bprm_creds_for_exec
> 
>  include/linux/memfd.h                      |  2 ++
>  mm/memfd.c                                 | 14 +++++++++--
>  security/selinux/hooks.c                   | 27 ++++++++++++++++++----
>  security/selinux/include/classmap.h        |  2 ++
>  security/selinux/include/policycap.h       |  1 +
>  security/selinux/include/policycap_names.h |  1 +
>  security/selinux/include/security.h        |  5 ++++
>  7 files changed, 46 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> index 6f606d9573c3..cc74de3dbcfe 100644
> --- a/include/linux/memfd.h
> +++ b/include/linux/memfd.h
> @@ -4,6 +4,8 @@
>  
>  #include <linux/file.h>
>  
> +#define MEMFD_ANON_NAME "[memfd]"
> +
>  #ifdef CONFIG_MEMFD_CREATE
>  extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
>  struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
> diff --git a/mm/memfd.c b/mm/memfd.c
> index bbe679895ef6..63b439eb402a 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -433,6 +433,8 @@ static struct file *alloc_file(const char *name, unsigned int flags)
>  {
>  	unsigned int *file_seals;
>  	struct file *file;
> +	struct inode *inode;
> +	int err = 0;
>  
>  	if (flags & MFD_HUGETLB) {
>  		file = hugetlb_file_setup(name, 0, VM_NORESERVE,
> @@ -444,12 +446,20 @@ static struct file *alloc_file(const char *name, unsigned int flags)
>  	}
>  	if (IS_ERR(file))
>  		return file;
> +
> +	inode = file_inode(file);
> +	err = security_inode_init_security_anon(inode,
> +			&QSTR(MEMFD_ANON_NAME), NULL);
> +	if (err) {
> +		fput(file);
> +		file = ERR_PTR(err);
> +		return file;
> +	}
> +
>  	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
>  	file->f_flags |= O_LARGEFILE;
>  
>  	if (flags & MFD_NOEXEC_SEAL) {
> -		struct inode *inode = file_inode(file);
> -
>  		inode->i_mode &= ~0111;
>  		file_seals = memfd_file_seals_ptr(file);
>  		if (file_seals) {

Hugh, Baolin, and shmem/mm folks, are you okay with the changes above? If
so it would be nice to get an ACK from one of you.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c95a5874bf7d..429b2269b35a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -93,6 +93,7 @@
>  #include <linux/fanotify.h>
>  #include <linux/io_uring/cmd.h>
>  #include <uapi/linux/lsm.h>
> +#include <linux/memfd.h>
>  
>  #include "avc.h"
>  #include "objsec.h"
> @@ -2366,9 +2367,12 @@ static int selinux_bprm_creds_for_exec(struct linux_binprm *bprm)
>  	ad.type = LSM_AUDIT_DATA_FILE;
>  	ad.u.file = bprm->file;
>  
> +	if (isec->sclass != SECCLASS_FILE && isec->sclass != SECCLASS_MEMFD_FILE)
> +		return -EPERM;

In the interest of failing fast, this should probably be moved up in the
function to just after where @isec is set.  There are also a number of
checks that happen prior to this placement, but after the isec assignment.
While I don't think any of those checks should be an issue, I'd rather
not to have to worry about those and just fail the non-FILE/MEMFD_FILE
case as soon as we can in selinux_bprm_creds_for_exec().

>  	if (new_tsec->sid == old_tsec->sid) {
> -		rc = avc_has_perm(old_tsec->sid, isec->sid,
> -				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
> +		rc = avc_has_perm(old_tsec->sid, isec->sid, isec->sclass,
> +				  FILE__EXECUTE_NO_TRANS, &ad);
>  		if (rc)
>  			return rc;
>  	} else {
> @@ -2378,8 +2382,8 @@ static int selinux_bprm_creds_for_exec(struct linux_binprm *bprm)
>  		if (rc)
>  			return rc;
>  
> -		rc = avc_has_perm(new_tsec->sid, isec->sid,
> -				  SECCLASS_FILE, FILE__ENTRYPOINT, &ad);
> +		rc = avc_has_perm(new_tsec->sid, isec->sid, isec->sclass,
> +				  FILE__ENTRYPOINT, &ad);
>  		if (rc)
>  			return rc;
>  
> @@ -2974,10 +2978,18 @@ static int selinux_inode_init_security_anon(struct inode *inode,
>  	struct common_audit_data ad;
>  	struct inode_security_struct *isec;
>  	int rc;
> +	bool is_memfd = false;
>  
>  	if (unlikely(!selinux_initialized()))
>  		return 0;
>  
> +	if (name != NULL && name->name != NULL &&
> +	    !strcmp(name->name, MEMFD_ANON_NAME)) {
> +		if (!selinux_policycap_memfd_class())
> +			return 0;
> +		is_memfd = true;
> +	}
> +
>  	isec = selinux_inode(inode);
>  
>  	/*
> @@ -2996,6 +3008,13 @@ static int selinux_inode_init_security_anon(struct inode *inode,
>  
>  		isec->sclass = context_isec->sclass;
>  		isec->sid = context_isec->sid;
> +	} else if (is_memfd) {
> +		isec->sclass = SECCLASS_MEMFD_FILE;
> +		rc = security_transition_sid(
> +			sid, sid,
> +			isec->sclass, name, &isec->sid);
> +		if (rc)
> +			return rc;
>  	} else {
>  		isec->sclass = SECCLASS_ANON_INODE;
>  		rc = security_transition_sid(

We're duplicating the security_transition_sid() call which seems less
than ideal, how about something like this?

  if (context_inode) {
    /* ... existing stuff ... */
  } else {
    if (is_memfd)
      isec->sclass = SECCLASS_MEMFD_FILE;
    else
      isec->sclass = SECCLASS_ANON_INODE;
    rc = security_transition_sid(...);
    if (rc)
      return rc;
  }

--
paul-moore.com

