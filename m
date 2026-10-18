Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE2ECCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 07:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D436B0088; Sun, 18 Oct 2026 03:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE376B008C; Sun, 18 Oct 2026 03:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217106B0092; Sun, 18 Oct 2026 03:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3B016B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:59:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78BAEC0499
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 07:59:40 +0000 (UTC)
X-FDA: 85334997720.21.482C4ED
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	by imf03.hostedemail.com (Postfix) with ESMTP id 534D420002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 07:59:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lfrWoAoq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792310378;
	b=voAQ5YNOuaXipp4VQVtPJ4jakfE3gGsrkkGFDPfxR0rOYsm0XeYIbvt7fwrdBiR65e36WE
	7E38Iil+3a4dpjPBS4s07wB8JbTkU4736eTucLxnABzFODljaxRK8kwqH1ebAr5PhONCtk
	h8Lap1zzrS0PmOHHV/doamfqAFaO3mk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lfrWoAoq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792310378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyELolJu2xi7BInGaBj0/nHK9JAkLFJ3iwidm/fclC4=;
	b=BzAfKT0qZ4Dp8QVC4+Yzr8yzE+DsmIkfi5BgksTnvY4D8i1ewlImHPM86NaAdnHQC8uCn1
	0+tn7DFcjXXQcbE+8nhOw0v0xS+Lv/VYU5n3XVz9elkbeOMflEf1Ige6RHZ8nBtReJ++kn
	yY67RC/f2rwk1W5jb6Eb1KiwH+aK0IA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lyELolJu2xi7BInGaBj0/nHK9JAkLFJ3iwidm/fclC4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792310377; v=1; x=1792915177;
 b=lfrWoAoqPBnkUHg2TbGWDXZnc3sz1EwVdyHFT9QFlOOqd++K/YkMRCXa6Hy1w9702VnPO7F9
 bs7chR5uCdrXv7hE5tlHCqjppDu8zNGXix1VyMDYs5Ax55vtWtz4JU6jg9T5WB2N7em8yVI5Ncj
 GEBYURkYJvRqug+9Gusqvq08=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 77426602997a8cfb;
	Sun, 18 Oct 2026 07:59:36 +0000
X-Mizu-Trace-ID: 77426602997a8cfb
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 07/10] mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE PTEs
Date: Sun, 18 Oct 2026 15:59:27 +0800
Message-ID: <20261018075927.2979-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-7-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-7-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 534D420002
X-Stat-Signature: 7u3g8cupb4i4rk8ecf5jebe4zyyoobyj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792310378-929258
X-HE-Meta: U2FsdGVkX1/UL+qxJ5ozhtycQeyKEJP6x66C7LegcOJ4qkpsW6VuT6PuRSi0K+WtLeHqKJDQOdIOv3hZZyVJFtJb3At4OuDwyBdfudivFyqJrFptYZW4qutTIgG9aKMF1mRweTV7hxpZ/QUPLlhSAMHp3cnUIqSbC275GT6hOCN5s/HxXCCsR68VPumItk6cMQEboeSjUTlN0l3FiiZU+CklyeWFQGJw+j7eriumXTJPXizoMITfNEEmCn+GctmJa9QCuSwG5wjGwTpKKJ2Z4E0anG9rc2Kkf9ZdS0lFZOj8CawxmUvYPpT3oemhseugAeuE0OxKT94ZNO1lFZlvZ9NyHqLlfAr+5gzgePvuJfbozltokSpR46ZzCob5NV7kvAMdhg+w2oWx4Isf6LV+xVYTpB5PXBH1xpgEmnJMqQMOGouAfZscMIfcVz2dKTFeRgUy5D536E0f6CMzoTvbuXKWiuaeOzmDQHkniGOwmEor4ZtwyVySKnvWXuC6DJ8bOYPLtOEdu60JcK3uyid2j2r9Nm9J4CKmPTQ+Yj4b5wvochE04HHQ//ajCHKV5oBojnzjZKWM4Fij6JZNitXsmKtwOplN6PfZm5esICluyR5hCJEO44T5ZgdBDdKC1kEQgc8mYdEC4Tp96Pq8erC/aX/278DmXf3tB2QfyDGS7hOCKFF2EoI6hX5TX4Ehwl77IK9UmTypARwBPfTldl0uLuACBCrz3VzfjPy9T2gRLXekFGtyGMohG5krGbUL6IhhrLC5U4XzInnpq+gMURCaNDTVP0ODWkTIPy5g6pLZMV1HW65l/+ARkPtEhiDPargMrUP4Oin//2kIwqhshTYksP4FOkwtv9L1nlFirNG08s5HVchbR06P5mFXXlt2v/V1E6MjQqXaS9db2pmpoSbCMjnoIO/VOoc6j1OA6suxkq60/hRtrIZE4hXTj6WzRyJXtDrtIpwtmQaHs9+GMkb
 AjbZAuzw
 UR9VUs0FjzfgXYXyuOkKxYDj+CFWOPE+QS3UpqtHtKmEIzDOB/LRxqL5ZIunngtN07U81Qc2JUPj4QnWNTggtORB8e4Y3/qr3S8Ze4fXO1aWXm8J84sZ6CXAEM+/d9ASqI6mCM7EJnmoEPUpatEuDJLzwTYFPt58HG7+mnGzQjXgXd1Fli+1D5RzacfKYuUY8HmJjDlxxWhvjMBdlxkt7uXyZz/Jt+aoYZBNBNid1TZFmeEENDoYxnrg934I7X4fzV19CKvjrEWLCpwJBkup3zLWIlxLJNnV+YgIRQcbFe66yuoGMVwwtSuSui/C7mD6zPiEXnqZlVuMByj0S1SvTbqZWddF5bTWFN3/xnxDIzFo+B7b4eAAy9G4l+XPA9D8l4u03
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:13PM +0200, David Hildenbrand (Arm) wrote:
>The whole uffd handling when a VMA is unregistered from UFFD is shaky:
>there are still some scenarios where we might have stale uffd PTE bits
>in VMAs no longer registered for UFFD, which confuses other code.
>
>Let's just tolerate that for now and simply clear the PTE bit. Add a
>TODO to really clean up any uffd leftovers when unregistering a VMA from
>userfaultfd.
>
>The handling is now more similar to what we have in handle_pte_fault().
>
>Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

