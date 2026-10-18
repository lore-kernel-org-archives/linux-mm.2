Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8DCACCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 18:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97176B0092; Sun, 18 Oct 2026 14:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47F66B0093; Sun, 18 Oct 2026 14:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35F86B0095; Sun, 18 Oct 2026 14:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2D06B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:29:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0E8FA05B1
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:29:12 +0000 (UTC)
X-FDA: 85336584144.17.674A0E7
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1D7EC40002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:29:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OvtNjj/T";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792348151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhL7iYYfEcNdbRQqdb6S37zX0Ja75Am4y9nFDdcH8xg=;
	b=XP3lyE6oWXwIX+UoNcpCpHcb7Y2yN5ayC+JQmrg4F+JZ9XpDKnDZXAJHsqJynVvrab9qfd
	zhw3krkMBoAZIAEDTOY9nJd07nOLafeShEviFBDIrCD9b+5ku2eUB7fwYaqdGI4zXzZtg0
	4aDljJsaqj82WFupGDmU9eltMUlVQLk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OvtNjj/T";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792348151;
	b=tXfsSz0YKRDeOXoWWSbo3Yg26vnZmJcDcetJGMqzcoG+DlUiEuHcyyqISfNkO6IDURK+Id
	r/vn3jymWoBIKKSRWqemE7xq8aAt5K09PUCmRgkIwzwmBFK5Y0/IG9Q1TOVxGIhu5AqWrK
	Bsx0oIsKSjdNPs3D5r+IYqRvbaaQSpk=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e977109392so5528765ad.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 11:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792348150; x=1792952950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qhL7iYYfEcNdbRQqdb6S37zX0Ja75Am4y9nFDdcH8xg=;
        b=OvtNjj/TCRMj/F5PP6fLMmfBw3exFqhywGnqAOXnfHQ193AvfjQXVkEsjKnAly8Rof
         GJESX9o7XF49zGGE/+dLENoyEwMT+ctOOwpr6mUH8JGkpIckkyA4VDgYHIlBDM3CxIP7
         vtZSFD+zJsM0RidIkVvnx4aiuQqwimFIM0oR8C3ujJC8UBE8L2SEqmuV1XTN38gm0Y+0
         qsWH2SvoljJi+XCHQXDJ+jKojixbeNYy34jpE5l7R/0dNYHogbYdNcSlLuqlvH+t/3Ul
         7m4zOfNsQ6Y7JvADgt9hYfe/C1XrXbMWjK+0V8U1t49TXEa7hJkzEHygNxLelLs924WP
         PkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792348150; x=1792952950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qhL7iYYfEcNdbRQqdb6S37zX0Ja75Am4y9nFDdcH8xg=;
        b=qgPAYDi7qz/YbGHHEnNVmuPQGPTIa5h3/YfzdZBpif3olGlizwLyU1kIaBXJ3ROCf2
         50RH7FmKd2M19S7EZ9fu3l94Pg0rOrNhFIUfmqQtcgp4b2rKJxUVoh3pyaOs2fC4TNSY
         IlWgFTfwf32SsUgqtQkx+CyJVoobM9nv4thvWMMd1bO1tXDQ39cwl1DpDSBr0EhubhBF
         TXV3jGTww4vaNxSbADyaIYWlBXstjilm1z6XWZerXwbL+HrZBmhBx25HJpQ/XqrMSUqR
         rUpQJbLYgAZILqfcVdZzqiwgLtZDL88xI63K2TV3YJ/ps4FBAKM8Y+znhfD3UWJtz5WE
         w9AQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZ2H0eJZvrW5WEoyyUcQjQSWLQryvh6TemRIT5Ty4K8k5KZmPbThTVYnI3ujdupSfp+dANfmj3gg==@kvack.org
X-Gm-Message-State: AFq9FYLBYfRkgp/O/qHx3HGabSz1ovg9vuZaC1kSuuCyZkwxBttyZWVT
	6QLCzyIVfnOXp8V/A/uH/Cxp3zTqVghDcXIdszWAubQfXM7BT4Q1neit
X-Gm-Gg: AYBFou1V6V+gFEY99tIHJvJuK4AkPeVUBzWbo/rhlqflElZmtzz1ZOmnqXdYjWF9tr4
	qP5fP91mfv5+q1v97GbkT2NllFyTeR6tLE0cRGs3Mh+iqqXtywj/6hNXKk+l/Iv2Y0zaCBMVS/F
	M+7bVcY1HM5864wLqXef3ohgV4gGlYYGGZiBZCJxMOfbF+mVSMSGTmocl6GDb42MILmn8xDAIBH
	zaPBKZKb02p5msYZG+Vblz2gUWzJeaEMMpJuRpFGaRH4VKITZ69Xvg89ag4y9hpSnWRB62E5GJr
	kg6H0PoChC+Vtq0qt9+stK+8INhDHmRohJjI4lXr0D3KWX+dcml0WcNmlrhgIbloH6TxKtib9s7
	w4gDCCEem+s3pKnov5bdyB9LyzOtb11wePz/PsHfT4Ln6fFQqY8Z3lE4HuCos9yHvde3Ifk9ZAU
	rOwGutZmxz00iJ3Wufe8Kvg8XVBqVmFqa8v916y2Ckov4W78bZMiNNT0NNLFyDlYp57g9rUT60q
	FvDZuQUeBW8C7LRhOuLyjLk1JiEv7F/72NPd3JhuSpqKU2aHNIQel9Y4gRm9zRjcs3a0HCp4esN
	7oh/RgxNg6Lz1ei3JV4gx2ZOAQ==
X-Received: by 2002:a17:902:ea03:b0:2e9:7719:4104 with SMTP id d9443c01a7336-2e9a6834bdemr43504965ad.8.1792348149928;
        Sun, 18 Oct 2026 11:29:09 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (114-38-149-183.dynamic-ip.hinet.net. [114.38.149.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e5d4e51sm29796255ad.1.2026.10.18.11.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 11:29:06 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 4/8] mm/gup: break out follow_one_pte() helper
Date: Mon, 19 Oct 2026 02:29:00 +0800
Message-ID: <20261018182900.671-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7ba9d2e6370d6134ad34cdffcff5cc79b9192df1.camel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com> <20260811025157.1632867-5-riel@surriel.com> <CAJuCfpF47Mpi40=8yujBNruCDvY-Ezk0WFEacCqxcdRjmUqt4g@mail.gmail.com> <7ba9d2e6370d6134ad34cdffcff5cc79b9192df1.camel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1D7EC40002
X-Stat-Signature: 7p6efjtrhy6dxc4sg677y3x15jiwckxs
X-Rspam-User: 
X-HE-Tag: 1792348150-984059
X-HE-Meta: U2FsdGVkX1+7m2zMVuDBYH6l/Har6gxs+zXbUOspJd/0rbvYx+3A1E90qLN0jgZWLtbYr8mym0bsatwlJ6IDm+OPpm4AH9+O6EKtbys41XC+mFxHU1U8mvRgpL710RLt+uq5MUsHI7H2PXaLM1jT7RH1G6BefCLVuW3u3eJ8Ifx1LM1ol1KUVvV3bXFyXdqOd4rY9Oszm/ShuXXjyYI6ZSVzZOQoGgS5ah4KbAYOvxw/V+PjA2BagYJaykUPk7v66a3TW7/PISuzIIbxpE08DQiVNNT6aAdE87eLobgrDZsmxsXPB+fLEzVR/5ESD1kQncioAY3+fLPL0rOyjm0aiIDmjMiS0JKfuGwvf+gWnNhy9S/gvtr6fALH3baBpbetAXyG1Wx2xBIC4MwZG6nk1E5gMo6bBEAh6xmc7BZNWjGPbgSL0yjfmhQcwWxyp5XN0ahKbkTo7uy2zv6bIaeKrEuh7qcZNUOFxNyclWQz6Q6ZjUHWn9Ix0a2Y/16C3NJv6Go82PrN4ojjnqiqSkD7amBSbcXliTyM9mKJEkPWeA6J1fySa03ekBVpIp1UQVI21vQ+sads0ujMayp7s0GQSOfOZ3xdEk3m06B44L9czUUB6frb72Tf7RmGlzCE+Kpo+0Fq0Jn5p9mDUnwpuqxcOF9N1OVFQg+qgjojeyXJfsKKMeEHUbCOnfIZD64e55qwnJd+2QLameyunoS7fDHw51St61ntZ2pGI49NB/Zlug3Y1iM6HKvmac3bwnqAxb4yvo4kzKBenjQh6JPFV4PZ0GWHy24yQFVGytJI25v2+Q0KzQVufDthri34lU9NBhUE69H0+6Tlhsh/gSE0tVy04TxtVaBaUNSWFc+m/Q0E8fC3TDzGzXj2Z/RuXx3aZP3hcESLA8NKDVFTdhCzIzLFMDuhO2IezwBMVWcUAsekKwJDwxBOnlydlolt5c7Fp0Nmbc0KYF34lM14aDMAbBg
 JmzBysS6
 D0q4Yl0EiyjON/ikeTItOXCelsFsRdobON0mMmhWgUmdSM+Ue8sigTtypBWwG0Qn0hP4/LjzvMltCJEdbUKHTC4jerT87Q04o9EyfWeitp04k43oY0ItMIbyooEP+5iPqT0eszQUEkMmAKIQDnVi2Chtk+YZ2TfaM3d5NuT+mP/rGuNMGYBBGqAkAAvxndFM2uwJuG3cV/QUZ+ar6i6Gn73VES8Nrc/YAy7fW/qKFLYqiTcW1Ozddre70rNnhhxaax5dcI5k2Rstl73cvztDdNjV7/PEIxM+O/Oo3Hu+0udDnlFcZ9V1zPr5140DLA6xeRbDrHf5pvmGylu4piy3yugtsqex+c719rS720NZMH/bJYd+fASRQnOTs9CIAPu2bPW/SAOPrwGsQ6igDtol0bJpWLH5tCiFFThcBFaABK4ryrtE5ageZbhmaQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 22:11:07 -0400, Rik van Riel wrote:
> On Fri, 2026-08-28 at 16:47 -0700, Suren Baghdasaryan wrote:
> > Before refactoring in the above case we would "goto out" and
> > no_page_table() would not be called even if pte_none(pte). Now I
> > think
> > you will call it if pte_none(pte). I'm not sure if this does not
> > matter but this seems like a functional change.
>
> Good catch, now we may end up calling no_page_table()
> on a VMA where we are not allowed to write, for a
> FOLL_WRITE access, while before we did not.
>
> That might turn 0 into -EFAULT in some corner cases.

That exit is reached with a present PTE: follow_one_pte() has already
returned 0 for !pte_present() above it, and pte_none() is false for
any present PTE.

So "!ret && pte_none(pte)" in follow_page_pte() can only be true on
the !pte_present() path, and the old "goto no_page; if
(!pte_none(pte)) return 0;" sent exactly that case to no_page_table()
as well.

The can_follow_write_pte() and pte_protnone() exits still end in a
plain return 0, as before.  No functional change here, so nothing to
fix for v4.

Yuan-Hao Hsu

