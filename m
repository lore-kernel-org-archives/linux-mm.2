Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A941FCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7C56B0096; Tue, 23 Jun 2026 05:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67EF56B0098; Tue, 23 Jun 2026 05:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595E96B0099; Tue, 23 Jun 2026 05:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 287736B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:07:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93580166A6B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:07:38 +0000 (UTC)
X-FDA: 84910599396.30.4676410
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id BEECFA0008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:07:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YoAkfJEb;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782205656;
	b=s1Bb7fc7NnNglEI6g+s3EJgMv2M2ZGad99nHuVRjT08RQ5DeQ7NiaAs3zxROD6x7nrq675
	jWYfBj9LfPxa/Wlhk8WSXb7IZ53Ov8c+A7Z0Q3du13tN14r64ZyiQtnWLnX3wcgeYcMibs
	DFV+uMia3aa8n42Aeb7KXQgaum6iksY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782205656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6spHrHgBqIXLs3oShth/eK080eFpchGrRDS7859a1QY=;
	b=trcOiTcwDKvJ2MXx6DgyIzyVf9NMfifpZbOOHigS0Q5IrJ4th7/QQB9VUQCPlrYFcbJnkg
	Vhkvpno1EOrvDEliwJW+GS4UlaqrbsRyuRqRITu8pdMg/XhCUoJDXQ09MaU+FJy+8+gSE+
	tZ1BkgykRtQaUP9eSSoOMNBW8ST2t0E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YoAkfJEb;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37d82f3a244so1193082a91.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782205655; x=1782810455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6spHrHgBqIXLs3oShth/eK080eFpchGrRDS7859a1QY=;
        b=YoAkfJEbq97PstEMYyFrmQ8+6q6RLP7kHtPZnqtEqtRlcHHH1ePQth/vxXWIcIAFZi
         MsHyXM+CpCb44/+x0QghMEkd9g/BaaqFIdnW/kxK1EopCRM2hmeD/ZNgNQNFBuyr2ng8
         cnA7Y46Jyt/Qz3GxItX+fbgBB3gCKZ/ySee36bSv3bXFq5Ql2MxLHi8EGRpAD8ZdpjIq
         H0BlTEZSuaFp/f+94GFBp72uEj6vvnp94jeLA6KN1p3hfFqZXi7ZIwy4Y7K+7/w964a+
         CkYcqgbMSyd/JHNz1tHLPJ4H9JftbMFrw5uk1lEJXu3s4Qs5J3FY4oixBdnEl/EPFkbB
         Igzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782205655; x=1782810455;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6spHrHgBqIXLs3oShth/eK080eFpchGrRDS7859a1QY=;
        b=SmT78FmXpyp3k0peREqD0f79Ftm+lk9fF4mA5bISsrFt04Zj+8fdSIdPDwsyx/jg/0
         jaDrolmU/VRMNoq6qdH7y90PZCS9/xPDZjeA9Zyo9tvzl60mVEcXQ9YmOYWV50s0DTtx
         ywJGmYR6xD9U6HgwoNskUtpnNcWBt80I0FbwunwU/dlL0JvDfdsLiCmda+eHSdBFBQaK
         DbXS3FazwV3B4oVYYMRehVBQyqthP14tegMOdAxIlfe4dWc106xWlvWEcT+H02uCffhc
         aLE2YgSJ4xDzfQHjjc+R3K/1Ymjb1a2N50A4iybMOLayKm4B5xHxEs8KoIjIefOTm7TQ
         aETw==
X-Gm-Message-State: AOJu0YwhR2d6tadu7RQsEy2OuwD4j5pqz4Pl+13+e4PMzudKLbobDXdD
	LzOJMr070hBiQGRFCCUpJtQFB4LfmldDzD1udLTzIgDZAjPEcAzgf7zi
X-Gm-Gg: AfdE7ckDns3THdjstns59T6qvwpyWSHpqDrGIll3bC2fHndxhg2nJjhTGvuVZ3PGvUi
	rnlB+K78+SAnr6zQpM3seEiqO+fMZ+15sR3BCq305S5lSGcSIbKH9JherHUdOAi63O1C9zG4pqi
	gcEQ186I0oDDb+vih0gyF2jSTzKNEnFmEkoLhQhfFvj5jOUT423uR1fI6PMmq4ZJfdckehEgQN8
	m1nfLQVmQR2vyWctH9IRHPbvfff29pph8Va7vXlfeGlZxjzU2kYVRQr3uUjFuAW8HSEmsgrjEHe
	fnSnryob0rWZSueOF6UyQweYSgmLGN+/QEDzpwRV6cQQevfOuinrHmi7hoXu+hjDi6W/9eDUnHv
	jUT6lAMcDiC7HGFQeIbH6xiah37jzAk4wT6f8NayMQ4ceidOLoiX6sXyEsXr2tULonSCr2UJJnI
	B7Gw3NRXznXisKg0qYqlF7aYCIIA==
X-Received: by 2002:a17:90b:43:b0:369:7433:2fe with SMTP id 98e67ed59e1d1-37d4d834636mr13010957a91.6.1782205655379;
        Tue, 23 Jun 2026 02:07:35 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d15df7424sm12256623a91.14.2026.06.23.02.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 02:07:34 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v4 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
In-Reply-To: <CAGsJ_4wFVcNi2h_=wjycYGf2eHBPY-oc8aN=-3Z4wsXnT0+LYA@mail.gmail.com>
Date: Tue, 23 Jun 2026 14:33:54 +0530
Message-ID: <zf0lwrut.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com> <ecbca3be3fa8bd7e213d013a2ec6ff9a11c6e0d1.1781843449.git.ritesh.list@gmail.com> <CAGsJ_4zxcp-jdnRTn09b8ZfxT0P7suFq3BEpyiUzA2C_iRRUGw@mail.gmail.com> <1pdxybv5.ritesh.list@gmail.com> <CAGsJ_4wFVcNi2h_=wjycYGf2eHBPY-oc8aN=-3Z4wsXnT0+LYA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3ntyiq5zuxdnpm7p3fhz7pm37qk15hap
X-Rspamd-Queue-Id: BEECFA0008
X-Rspamd-Server: rspam06
X-HE-Tag: 1782205656-726625
X-HE-Meta: U2FsdGVkX1+NA+PZCTHbqCtRQP5uajLHm5JwKMO7y3JNFk5IAqs5A0OLpTTEBxrVZIfT/0vPJUQcD1e+Iu2K3Fzy+LA7azh7nwJQxaGHhb56blGuhT4pyQU0jjhfi7AFn6yb2RW558cgaS7Fn/h8Z+Owl2QB1SP32QvOJxSmpX9t2/emBrPo9ObQMuYjk27jawERFKAD3grEIvIpwVYBIbTM3w5/y4HZ/gyjyhcejYJPFBJBKojE3mpG1IP9Mbg0eAJdvCPYXSwc6qOTlYmiaYvL24JS7qui8MHeGv5pjBIJsYL3YzX2QSWGPmCvRep2Xk9XOAM8CLHkQ0jCtU96p01TQ95o3kW+tVPUbFgBIUzNPumxSR9xzqUx4AHxem1z0igpu2zBIUWpBo0uL1tP2s4PlIflWwV14MQ0rDQivP/ZDjQN78nYjM13XvYi3B1gPWHBE+WBeHnH2JtzEII0spe5GonyVvlkjxyOyDFkPqWpBPm+7+z1fHTYEa0V3p65pp8mvnJOI1qdAS62qQV/NaRkFHWoDkorKr8IJJH/d1u0B/BsXOOj8USkifKEax1CRWaO/1qHTqtYKfQv/m1iKUuySzjeORgU00SZK5km6jmbzwPK6pKeui54fARIP+1fwr4DDeBwdxkEfMqDDzqkiXtQBiGjobRuAgnAB2xqpGe9GTxE43wuLbu2Gi6+GtovJ3As1+W0CvpbYb2gO6B2wVItlaIIsizOzJwpeIuBt0SuWpLOx5wE6ngBdeYBJpS39EWuYICXl99qXeovOxjKbStISeSq9SrWYWri2qrkl3namlHQ7LIb1hbtvxqqw0rq1k4f05KEdSO9CGgt3n1o5qdPtJkCLJna/dKYo4eiNo5uexf8aBr0Df6q3B9vb2vSvVl+9ukUi9+dz9mASLLtPuc6VW+EZmMMTgrq0lxrxh28F+9jYLMbtaCBxpgQqm39rSmRIlJamL0ZNZctNde
 3N+i/BTx
 9dUMCvGHOXw2JGskQTl14u7QvWfQDc5EfNuTHa87rIGGNc1TGa7NmAtbgN2xWGAaDaIsVW/Df/hpEoM+cPxf8qHVTCoKABuEZUXCKkAipz881KfpmwnpcbbvfST/BV1xuYW0GuYFh6VfvnPk9HmAjcv9hY8B5edi8O/3DBik23WQ8+B6TJ92A7jp+b+Mq0AAYQQ4G3nmoqxk9Tg2ovr4OjgWYkwO9iNU1RP9RObH0UDwdeI7gWOIItQdEHbHs8xHDoSpSuy9hmElehSPiYcY//gNy/6KQCPKgpB/N0Z9+pM/QZwDcq0//OOT1Y547kl/llCMp1g70mKlip5HhRAhk21KMUTXPXaKkPuLeP+QX36s8qTbM4LSzAV9D85Rq1ueKB582/j8jCP19peJsWizGbTOMT9cNhWPAAEkSVNDsZ8Yra6Xmasq7fuvpBpI5NmawREYH36a/aOxPGluA1ksRCC0Ny0Mso1V3fhImMfQkoO5Pa8pp+nkyhyqP6dRNGM8fDEoYKh/Hy4r0dy41uhU7hcVroTQGfiLZcdR+gMny0GtFcTMYBDlMFAFfhZHeAN99MXWDGG2L/mfa+KGmr+vFsbeAIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <baohua@kernel.org> writes:

> On Tue, Jun 23, 2026 at 3:12 PM Ritesh Harjani <ritesh.list@gmail.com> wrote:
>>
>> Barry Song <baohua@kernel.org> writes:
>>
>> > On Fri, Jun 19, 2026 at 12:41 PM Ritesh Harjani (IBM)
>> > <ritesh.list@gmail.com> wrote:
>> >>
>> >> THP_SWAP avoids splitting of a transparent huge folio into 32 smaller
>> >> 64K folios (Radix-64K pagesize / 2M PMD) or into 256 smaller 64K folios
>> >> (Hash-64K pagesize / 16M PMD), during swapout. This improves the
>> >> swapping performance since all the bookking & I/O submission happens
>> >> once per large folio. More details at [1].
>> >>
>> >> PowerPC Book3S64 could not enable this before because PMD_ORDER is
>> >> selected at runtime depending upon the chosen MMU. The earlier patches
>> >> in this series turn SWAPFILE_CLUSTER into a runtime value and introduce
>> >> an ARCH_MAX_PMD_ORDER upperbound override for SWAP_NR_ORDERS. With those
>> >> changes, we can now enable THP SWAP for Book3S64.
>> >>
>> >> This increases bandwidth throughput with zram backend for swapout by
>> >> 40-50% with Radix and 100-130% with Hash (Tested by Sayali)
>> >
>> > Thanks!
>> >
>> > I am curious about the contents of the anonymous memory being tested
>> > and the compression algorithm used by zram.
>> >
>>
>> I am sure it was derived from your microbenchmark itself which you had
>> shared here (so repetitive pattern) with default zram compression
>> algorithm. Thanks for that :)
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d0637c505f
>>
>> I think I got your point - I can mention that it was a microbenchmark
>> similar to yours and not a real world workload test. Is this what you
>> meant here?
>
> Yep. Please make it clear in the changelog what kind of workload was
> used, as different data can result in completely different compression
> ratios and compression/decompression costs. Consequently, the reported
> swap-out and swap-in performance improvements can vary significantly as
> well.
>

Sure, I will update the changelog in the next version with more details
on the benchmark ran. Mainly planning to provide the link to your commit
for the e.g. microbenchmark code we ran along with few other details.

> w/ that, please feel free to add:
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks Barry for the review.

-ritesh

