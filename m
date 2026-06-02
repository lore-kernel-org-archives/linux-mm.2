Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B861CD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 00:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1E26B04E2; Mon,  1 Jun 2026 20:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7DC6B04E3; Mon,  1 Jun 2026 20:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790E26B04E4; Mon,  1 Jun 2026 20:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB5A6B04E2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:50:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EDEC3A07D0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:50:45 +0000 (UTC)
X-FDA: 84833142450.01.6FACF63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51CCCC0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:50:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J0jvQxyU;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780361444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmCDHQKxGmU0NXkOYJU/o1U/xmaSHU/e02onfhGC6hw=;
	b=H0k9iJwUeWtpGngbuZ8LfMJ6HdemnmpyMytsJMhAWSCmgWIuHcLVzcvq9Csdfh2EaTOlD0
	5XN1PB0+l+Rt9CjndkhToG8cvxi4+opCnGaDhAzSyNu9C2EW2EdeFYCzAf4dVbdzwYwc5e
	ulSGg93YG6IdgK7HkwY0WlL4JK3bIjY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780361444;
	b=ntyNYqG+/dUyuo8dt7FvvcDlWSpl7hBIn6UxoA/P7BzIR2dusdcMPO33p3mteBgCS5sJDc
	meMdkKKtCcIA/SHf1B3/jKQo1f42fQ+ZIlyToBXh2hE97l6FKCVU3NhrSW28HC5JE/WOdi
	nSG96pmMpRavFfDw7M++JfsLnSJeazg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J0jvQxyU;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADA8F6001A;
	Tue,  2 Jun 2026 00:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C80C1F00893;
	Tue,  2 Jun 2026 00:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780361443;
	bh=RmCDHQKxGmU0NXkOYJU/o1U/xmaSHU/e02onfhGC6hw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=J0jvQxyUfDbgy8KBUh51Eoa4t4LKTT618EtplWjVH0iJBGkxHNpre1o4dUGVHSRYZ
	 CrTYRzlqBMYT5EKyNl3BwL2qve5jb/cnRH/D4RnLUPrXHijDk14/PTvXhHGqjmGEpd
	 nyuzpDwWARFe81Wl4qTEPwOeoCmx6cknORySJwK8=
Date: Mon, 1 Jun 2026 17:50:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Qiang Liu <liuqiang@kylinos.cn>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 386/420] lib/test_hmm.c:1170:21: sparse:
 sparse: incorrect type in assignment (different base types)
Message-Id: <20260601175042.97c9e6372cb3e9f23f4a0f62@linux-foundation.org>
In-Reply-To: <202606011329.zWs2BKy4-lkp@intel.com>
References: <202606011329.zWs2BKy4-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51CCCC0002
X-Stat-Signature: xk93kakwwzsbhy43w4twjpnmef48pfhw
X-HE-Tag: 1780361444-132326
X-HE-Meta: U2FsdGVkX18jF0znTiRCu1y9PwsWJRAZKS9EremO/xk4d2HMz8Ip1sZUDhiHukZYsPe7+ovTfpp+o3T+7CeLp1zwwDcdTUOZZOSUFmHF1NBHG1fF7f5v7rHP/zaZgNtvhnYySdvt1ORyTn0BCQYLp95ic3HJ2SazBmKfAL5pd45h51ZMC7nZi/HuvcoPmQE2y3+lvoX6MsmF9FnVw0C1WSTtXm9qVI/fep/dxUMM+cBrJqPALRI0lEBmjX1lBAj0tgEuDLQ1cIDntl8HxS7T0ciBbnkM/h23Ff2vuYsz/uMWkxuAlCvMf+TkTe1YyZdRW7w4CXV9QnG0IQV2zk9fZpEGensF5E+5dyh+sCB+DczpGH9B3MQRR71uQ8v/puha8oftPvQ3+SJF1siYRkfKNe9l38PLn6r7Y37HMVoTy0dYYeJ1ee9SN64xPE+ZioU1Hv5fWpz7BHSC0j+QdBLOA7v8YZfVtHv3bEbEK09kGNTt2aXUTnpVfYNsmDfdRSRD5LSe18WJ8bPRaiB6wgyJxnHm9tMvxczS1dUxJzjGtcUFn53Zm1UoQLh46mHFoCc7/e8YuUA3qWR/T1OTZTQLXGKC6CesP6/ez/cSXwFg1TzOQdKdCyb1QTEPAxG47GiY4XHHTFNvwk48ep2ZwDD0wMRvufSUTIO48jCdZiRQgi6oPJ0PzjoZyxKzz6j75iTPVBD8BJFi/VJeg1DU7Czzr6Ca8StrxBmTW/35Pe3CxtFaz7kEnfSNP6vYhT5wMm+lDn24Ai3reOXeFwKgAGZUI+vVGr+hOlF0JpAMQN0QUM+vIheXFy/4V8hjeyYvLTE9Lp4A65xxlm6zYj2WgvJ72r1P+m6YsfN/J6w2Wtpq0ucsliP0tdgUAUbJH/S9wCTSXxPLLnQcl+XKjckz623V+w8GPwRfFudMXGYI33/qOQlu1KoWDjT2OiES/uxHMZ/1CucAMGxMMmZa30Npjt5
 ik+3m0Dz
 02HqoE4oxBTbuPh+xSdqwhx7eaiXB9IMBB8k7QoJ6PR6eBqyNiTBhUKiLTNkblgWM2X57pz/UoIE3QQLsGnZJ5n0uNA1L4YIa6bXKASU+eKfe3vdO6b1K5BmZ457+My5CKhH2xB141CFGD6qRIH+dxwnsFbc8cGRyckGq5ATfnK4wrlYzfikAWZlui9YjqMeNxwTEA3erZjFbcdJTZutZYebOYt17CTNJOxF0lNZuXsFmvmvAtFB6amYZ/4gksyP85wUaiUxp1Bj0dIxC82Luyft7ZYKoA/xju89dO6jMGwuRjoUGvW6eYC8NMccK6LbonJsnrW7zYsatz/gmsMAcjEhw0PPTG3c3lrxexZZTcskwyoGG+mI6pQx9Ht1ENJ5va989X+YOQ4lu6dWV0sIWGBO331zNJOsAfaF9zzC1ClF7CLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 01 Jun 2026 13:13:42 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   d97bc98dadda29f23540b8490592962ebcf545ff
> commit: d4ab4875497b1659c6c56dd9faefcb4a41c566e4 [386/420] lib/test_hmm: check alloc_page_vma() return value and handle OOM
> config: s390-randconfig-r111-20260601 (https://download.01.org/0day-ci/archive/20260601/202606011329.zWs2BKy4-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260601/202606011329.zWs2BKy4-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> lib/test_hmm.c:1170:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int [assigned] ret @@     got restricted vm_fault_t @@

yup, the code is confused.

>   1165			ret = migrate_vma_setup(&args);
>   1166			if (ret)
>   1167				goto out;
>   1168	
>   1169			pr_debug("Migrating from device mem to sys mem\n");
> > 1170			ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
>   1171			if (ret) {
>   1172				migrate_vma_finalize(&args);
>   1173				goto out;
>   1174			}

How does this look?

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
+++ a/lib/test_hmm.c
@@ -1167,9 +1167,9 @@ static int dmirror_migrate_to_system(str
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-		if (ret) {
+		if (dmirror_devmem_fault_alloc_and_copy(&args, dmirror)) {
 			migrate_vma_finalize(&args);
+			ret = -ENOMEM;
 			goto out;
 		}
 
_


