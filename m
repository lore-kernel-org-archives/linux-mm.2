Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F76AC44516
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 22:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287CB6B00E2; Fri, 17 Jul 2026 18:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EDF6B00E3; Fri, 17 Jul 2026 18:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175116B00E4; Fri, 17 Jul 2026 18:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA5866B00E2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:08:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E2A51202A0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:08:13 +0000 (UTC)
X-FDA: 84999657666.16.BD1E8CF
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4FC4CA000F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:08:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bSlaSdH0;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784326091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fK1sV5PaPmcS6UhZ86Rm4HrquxZKQdzLRmcBNyv2BwA=;
	b=2S0TQ4OPRb4A3a8nrDh16ufE4hmg5gSBFIPQGv/lkHyPAITZgHqZHVya+OMsza5afZS/hQ
	HPH+HabEUMFX1IdryPfiJqjWW2xZXn1X/0tPCiVua9H44hKWvDZlKi24IxBQThqIVTCt3p
	AmDAJs0vXiUN984NbUQ9CIzRYinmih8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bSlaSdH0;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784326091;
	b=S0DMUD9gZC3WjwuLrj3Ed8NtffSvN9VPtoTC8eBqpIOJgq0JRKr8wvHtNFs+ZS2fsiTMIz
	PTuOHfTjcYLJxewBBb50LMrjq8Ob2B6K2m3knd9Kdr2Sx+ll2oRuL/MWm/eweu7el3pR8A
	UaA8D+w6oTLjz2OZsiOEELDWH+BhXQI=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e50a650a0so465939985a.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784326090; x=1784930890; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fK1sV5PaPmcS6UhZ86Rm4HrquxZKQdzLRmcBNyv2BwA=;
        b=bSlaSdH0xJ0wIMxZ3SDabGOqoaOyV4oMdsljtQfe4YEuQ7rCXsYzn87hxNrYJPeQxM
         SH5ZAJKDCua1URcw5kxkfQwvJC0DynLfpckV/lDrat0nlkvi1ero2GUFyk5iHrXcMtph
         CNDOoHTKrVSn9uhg4CQV840DlpikHMfr3bHMqoWsv2fg6BCbx7OXA+k/ZM9IjD7J/Oc1
         hfOompVVpvgHaAAt6+WqwFG+HC4g/SnxOw+IKBDDKMRLy4SkDnkfqkslSgx8IxPnjZbm
         W8ZPVCBYbt34F+dIsdwPyIrogO9DiQI9/DcKFxUUfw99CwSnKgGP0lh/ykIaYoTRcVbH
         AAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784326090; x=1784930890;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fK1sV5PaPmcS6UhZ86Rm4HrquxZKQdzLRmcBNyv2BwA=;
        b=oAMJi3YblGKofmXv4Yxy3mvi5LKF1mZI/GiipNSFo4o8ayksdvTOUs9Bt32xg3QTBB
         Q92PoDgvZB7+TPJUDd8o2sTzNs54MSwrzi5ODvInEwLphoR27IuIr4DV0ji124+1/Sh5
         yI6AQXOhuzAdeUcH55dUUZOSXsk2xHVDImpGjLuvD1dDDO7ckn1x8KJEizki/SiZqzuN
         aVh+Ua3O53l1hbr41dvcOIaI8JQKODFEOf53GHhwUiSlrcXLMB0PW2h8xqdKanNuHaT9
         KpUBKJtg2gec/IdXKVLBXpiM0lGv49s23SAuEm7d9SQBU8uxnOweCSk7serWTkUNT51B
         oudg==
X-Forwarded-Encrypted: i=1; AHgh+RpalUyBETA/fb74qfq45vPKCAnhUXSEvnVuV8spHEaRZO57Y8m0E42tKzD561g6vMx2ka4Ra2hAUA==@kvack.org
X-Gm-Message-State: AOJu0Yx6WpoSsLyS2d2uieX6mZMol7y3VIEeVUSRvJEYYjYc++2uHn0U
	gvOgKBi4Q6Xufz4NlETMmJCZ9QbSudgoD4QbigAeegJzwc1XpJylfgmu3TFtpghbnj8=
X-Gm-Gg: AfdE7cnz3xJSmd3mVrLtrD59fKkgQWxinWmw5gFu7s9nPzMr69ZyCWOwFZLUifwIPnx
	I1sTo8byr1oyuEmvRL/cXcFH3DtC0xtwoI+etrRe4GK/n6XUg0JSkaV6UYid773gW2JGHJefMVx
	JdL0fwEeNf9pP2Lk+9bX3xISRWn7Kc6kZfblMLeoOJSG/uc3aHUWlQgTZp8tBPjdqmGIlSu5Lc1
	gJnTO41F76caHy80+EbcQ3jrD3rO4khGUeFmv9ntQK6Jv/725xlEEcu+0WobOloENbdjf5WAvrS
	YC1OUOb44EHpPbYgwH4w2r5YSAT/2IsP7OyLzUmC6/WFZbbdj3NNLkxTqdYrYM4PwEvOv3hIQSH
	nJDE01FXWYUUduCniTNa0nJaILb118ybCQZoopNTEji1tGUJmYALmVUcZpFIuTS7sHkVFiJpoHA
	PyJjopwnRb1mBKPA9pcJhJh0NBeKghC29VtiQkEkM=
X-Received: by 2002:a05:620a:27c8:b0:92e:fe10:333b with SMTP id af79cd13be357-930b41f9901mr535269585a.65.1784326089627;
        Fri, 17 Jul 2026 15:08:09 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b52e0f87sm257411385a.7.2026.07.17.15.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 15:08:09 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 08/12] PCI: liveupdate: Inherit ACS flags in
 incoming preserved devices
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260710212616.1351130-9-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-9-dmatlack@google.com>
Date: Fri, 17 Jul 2026 22:08:05 +0000
Message-Id: <178432608536.189683.17937493816735356455.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=669;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=JvD6d52JVF0dw9KaC8NTS7eMJsBpt7DQsADyzRVcQlc=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWqfHpXPLQRJGmFv5A4z6Gn3ZGKfCiLrGZFJYE
 58dLVR/0DiJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalqnxwAKCRC7dyhM23N6
 3nFoEACAMT3npwEDLawBzNMz5alv6oFvn/SKvY0p3N9N7lfY9rerg7LRUYRvEVf+TYGrtjTjgKC
 XpMxGn6W9G3uCTaWP5/B5bUX9iOkHNBgeZ6CphGCWTNjgxntOYpHpXDUfUe5vPEuaB21BCKb00H
 /boplL+neL6/tFYPnWk3feYN28FvkiXpJa1w4bpLVUJaV81/l8du0RTTTendMCT/iM8CsQZFdKg
 XXIz6uulPu+EUEn6yHi0dt37WyEhuB2i4QzJS7uIqv0vtEHW9bjIe+yE1X5rEFCk6hEkUnkdHur
 woH+mrGI2xscTu2d4ymvl8mB7IRj8Tvl5mo8nEk7zAitJ0JSk6lRaDJGAY+C/PTartb0wpNvWUS
 Gm2Q/v//Ntjm1RUidQSBijxhimUnnhQ9SBzGFES2gijkXQBcf5d1679whVMjGNvppPHjwZsUXIk
 3RrGudA10XpLugTQr9B1GBQ5s2vwBRInivaoons7l4QpXJIUGxpApVRvlWVOEVrWZQbvPeMdtie
 +m7b7s30saS2X/yoNfNTf047Kms/LVNpUJrlS9iMDqANRGlM6iW4RW9XBPfzzcGXbKG9WkwuKQi
 BE/iu4Slr8z89z2CsULzwaGdgTjJivJg7eBPhDcDQQRw22q+lpeFRl5CGf/7I69oEYVuQ6o4QG5
 jAh5AuDVak+U7JQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: ffnoru5wta4nucrfi6p3fiwg8ebsb5qc
X-Rspamd-Queue-Id: 4FC4CA000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784326091-575882
X-HE-Meta: U2FsdGVkX1+gi7oUoAaRjO5UkBdWs8H9gIRXUnrwK9UzbOawqeLNkOxoCn1FTI07fjD4BW8XD2V/cLf/k0ozI9XJYTECKXNX2KQwkuYkv5x0BWlOy+Xc1DBTTfoUDXHn7ZH07Nrsk6s94NOeoCWD5cxlEzSQ4fYqNnjKBQwOUUWoUDgd8momf83KnIKHE5kn9dN4/yM7Xyf5UiF9bOhDE/ooROfL04M990MUCvaQuo5xeN25xmQVbImrJ1iqQy3CPqOMRj6cSysEjsCBQdD+0eflSE1FACHbG1Kyl8wDmmXLuNhiKLb1D/ErAzdYMyWxyQBKOj7HfysKeF0LYbteJUB26Hx7Q5obv98gUCG+iu/gGzjH1WuNq8/03IQkNuH5VRk7ucmKBnJI1kTxUlKGjH7GwsLxVW+ICVntSkI/94Iq/j25mqG8J9ll6uPvHZHE6cTb/hja/C0rCBWAa8VxJrV3uIG6EMJVZAorCTg1ZBcxfURyHByaElkIwdQrsUp2ws/AWLxgGvKtu03JyLf+0J9nW9uRx3HGvxRcFNQ6pUTkk1CF9dnF1jR/EP9xQCQSSbcXewdm8E7h0Qx7YTD+NMRSN1UQ2oCkN3RJmZ7UctjJjHhEhEtsh7SLDTlPRlxFrMDHn5Jaf1fd6MvOh9i8XvykuSHfEBt2lAK+1c4qWRbpx0Kf1e34YYwNF7zlVnhamQcBCeCJLTFvXZXh72kISmhLwFPzFsdpW/ykkpegEBPzoc4jXOUeGthKfo03hkDDJhemr/C9FC/xEcQR473tjoJedqY5SphfnbyNQO65HnY6vlbQTS33dzOCZ/LekXQXG5/yztQaY+AmFJ/Lpx74EJw7warDlVTw6GBqtvqZFwgX+d6pHzTEH9lZLKaTBV2RLhQsWJ6NwMAOd/u7Wv1ilg5mIARTo6Kfn5Yuhyru7C2SSFgm1e5laXBBJQjezBBOIk+BaaGzOc12C5EbhaG
 XZcL3Bgx
 AvNB2U4fHlyEg95mMF5Ca7UWzPEn6gp6QqqupDHIYl1XK7Wc2lH5OrzT4jcyq+SDyg6vVSpU+cSY2YUVCzqEL2OieePjUjmtJ4cnMlCndoO67fzMNJUzvdFJ1Lb3jWtH9gdgIY6JIAgLfFD4z2ATCWGKQNRnOvLXM/+acOG8eanFXLKS6hetqYShVv+sbJk/mIap9fm9SVjgSP8o0TLN0/caa7CY+xr5RMl/rjgTDA2vkneZjgLo/sb84YnoCKlNa+coJi63yIMkV46yphv5P9B/wmw2Eo9OvGnCKjUIg+IsMASQ3oxiVQTPph0a0aee428ne254gE15L8CPqCS8ZMkCt9I7TJKUWlI8NJcVAsx7Be7dryFxSIRDEyc8i1l0KBr7e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:11 +0000, David Matlack <dmatlack@google.com> wrote:
> Inherit Access Control Services (ACS) flags on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
> 
> Inheriting ACS flags avoids changing routing rules while memory
> transactions are in flight from preserved devices. This is also strictly
> necessary to ensure that IOMMU group assignments do not change across
> a Live Update for preserved devices, as changing ACS configurations can
> split or merge IOMMU groups.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

