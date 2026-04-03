Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B7FE88D71
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 22:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2218B6B0088; Fri,  3 Apr 2026 18:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2076B0089; Fri,  3 Apr 2026 18:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0E26B008A; Fri,  3 Apr 2026 18:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF7DB6B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:31:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7929F8B9DE
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:31:59 +0000 (UTC)
X-FDA: 84618693558.18.AA262CC
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9452C80011
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:31:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PO41HWnn;
	spf=pass (imf30.hostedemail.com: domain of wyihan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775255517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjuoZin8EjeumwxQWlEEfcXBzhIlUZuPBzNuCTkTKsY=;
	b=Y1Ip0qpjrYpqfD68Uzd88aQ75ZA5WEpeZbA26u0vMTdH5bKCtUYiern86SaJQ5MBBuklJ5
	VJMWpbpPOb4+1K+/k/1ptS60+sKj/WsiXq+gYo1GpwVVo9jNRgbgBR7vNw5wFsFUF6dKnZ
	qRDDW7iSj9yQElMCOcpd8JYUDW95RyA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775255517; a=rsa-sha256;
	cv=none;
	b=PZdRFfwXMoyC3A4RgaViZWrs56e/R2Q1j1TFIghryFEs3bOrvARYYoScOjDVTqI4whgHs6
	r0J44zwvofeSWB8aJ0rXDg3UzUz8S/y4RNNZFfIY+DbVf52dqqA5JcnEQC2HIYILFHWqBY
	4qGvhXMZ0JQZTXpUhR1HpoQQVF1B+tw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PO41HWnn;
	spf=pass (imf30.hostedemail.com: domain of wyihan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b0c12be0ecso134785ad.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 15:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775255516; x=1775860316; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjuoZin8EjeumwxQWlEEfcXBzhIlUZuPBzNuCTkTKsY=;
        b=PO41HWnnnMz/5e9UR6qoV8W9N2gFhX6j/hjAHY1bFDyclhIQ5ZQgPSSSDpqAbAMToJ
         ndBlbFdBYUCdNkgIRh+AZmnXf36vHhSWu8UIN06gYmqfsaM4UvR/H0Fi2XhF0sWGGmdj
         VmiwkmRbP6D+e8n6ztzTX81FbAdgA2yFTm+RXZ/nlpsXbBB5XszKEXo5duYgkywTqeVI
         c6psHvqmNVv5dTlwHuO9HFxVgyeI+0DoNfdP+6ECyZ9257ph5BG9zH2a+WXMTTAASVBM
         gTxUJ68g7tpqG7JlEsyDXX/2Ivy5Q6ZVIGlhofJRi9j15gMBnJcBzYnFjN31lMBikWhv
         bv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775255516; x=1775860316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gjuoZin8EjeumwxQWlEEfcXBzhIlUZuPBzNuCTkTKsY=;
        b=Y/bikW7sIRps73YOSQFPKD7dAs7IAQWF3qetPKh66IB4dlEwvaMKnl+1sYBsQMEkan
         yqvZLUdEFH3/WaJTAjZfeeCKHjwq1L0xthoAQb7h4qqUQaK/RlILXlb+N3hJOCFyLAEz
         n46PjHpVWPKaNftBVjhU+sYEdkRMsG/CX0nS4MYxBMhYt/nxJeHdRyxk2VuPDQ9VNkdn
         1PJGh4mpqtGq6VHtLQrwx0KzclRGMVhuxU9acJqQCT5VJPF5EI3La1nBg+vIDjS5pTk2
         /XOoV1VoZ5Y3DFfZ5PCZp0sujg7ANRkTuqgiTSleYO3gIS8eq68FW9sMOGMmoG6E9vH1
         XrTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMXbSrgXWJRUNX1vqrHMVu9T1bRkeduVPxttxxWdG12rHlu/SqVx0eDYU0FlKooi3qavh0xa9ogQ==@kvack.org
X-Gm-Message-State: AOJu0Yx12deGReUjOwJbJvjgGqGdLIboYBDDijio3XNSgr1QnSUCKDQh
	6A/RGy2+Cm8y14MMfG/nr0LuLV1MK/61QwhTOzc9ZQhFMNanPg5Hqm3VMx+H2hbvyA==
X-Gm-Gg: AeBDieuRjm5fxKr4kQ1Ll6qeuQjlCz/m2eoYx6ytwudK+M2LdcV7CIeh8C2fjNbzIoo
	0t1QB3RsvcxcZU37+tcaNiOMjfa0FRIyLpwXvnpLXp8qR99MgUmAIIpIYYm24Tr6wBtV6yj/CXI
	qqEPr6tkJCms5H36y6b2PpBLHp9xxz/LHPH32ddX5xOemudHkxF6NpQF6XYk2eZq3XOD4gozY4a
	IBlVX0vDodTGXLLrNXlpT/wJze+1DQLoK1YWmUYX2cwweLu0HdyNz/M9ReNatA/bA/75dyIOwQO
	sKclt1x4bxl324ouUXke/mub2X2ILUhqJQJ0tyOcBAmXZVxupNdNsCYnsddAMfahutGkPZH+Q4I
	QXwsZg3WzHb4R5HZGUIlg6q1qsm0QMXaJTq5CD1IE/35xoGvX+gWuVKI5M4vJyktIpnl3ORKit6
	6ol12ObUwkWU0QqQGNVyl4AdSB6mkHba3mS5SWQPqxp2TRyEcNlW0WORv6CHNfu9I1
X-Received: by 2002:a17:902:da87:b0:2ae:4453:3674 with SMTP id d9443c01a7336-2b282ed2eddmr3770265ad.4.1775255515833;
        Fri, 03 Apr 2026 15:31:55 -0700 (PDT)
Received: from google.com (115.112.199.104.bc.googleusercontent.com. [104.199.112.115])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe95abc3sm12613068a91.15.2026.04.03.15.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 15:31:55 -0700 (PDT)
Date: Fri, 3 Apr 2026 22:31:51 +0000
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
	tabba@google.com, dave.hansen@linux.intel.com,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/7] mm: memory_failure: Allow
 truncate_error_folio to return MF_DELAYED
Message-ID: <adA_1zXLUBqmSHFl@google.com>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-2-92c596402a7a@google.com>
 <2f177e0f-2eb0-48d0-b48c-7a0a340caf5d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f177e0f-2eb0-48d0-b48c-7a0a340caf5d@huawei.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: j77qjnwg9kqju6wnz5frxpdsheo4i5b6
X-Rspamd-Queue-Id: 9452C80011
X-Rspam-User: 
X-HE-Tag: 1775255517-112349
X-HE-Meta: U2FsdGVkX18p5xTztcuOQAO9OwaryH1Sdn3V5A0LOmPg9JiqCDUuMIYJOz6+NJ031LkZPIArLiuE/ceyavUHYyAs6cX9KfyfiE1xNBc2/EOkYrY61rHWUWJbHwTWM76MnxjTaJbmm6TgOFkmpshvFwfzFW810vVpW71Fpqk7KnnCKb86U3XiRWhd7SLJ6at0Hu4y/LaBHfuENwUs88fgl1ypJOOcivqfJxtUKXtI/ZU+KiEz4TTTKifKoUdDuYRLSjG9fNootLhzavdrffh6nnhO//MLDPAGcu/QxFvEZMkdSRHpmctw5wTQRtS/t87IftfFuokZKMAkag8xXx1jPVUMGX7FokFgFUTpXsh+ivBcYSYxxhqhcBjX89joJomMY5LoAkMNlImvX0fnP+x6c0Sq/BI0f88ReJtfBJoUDA9R7qy6/TY3Kzd/tcIfbIpOM3nLdb1GkIVt7x4pBElmTr68Pl4RHKkzQMlUSO0wuCAaRLa8AQiMIPjPjb5BolpgMCN+nV74kaodsPR7EukvIdwTK1RMGC+Lp5El9VVETf+Vf9mxYISEfSAZDgPcbLlXw3g1ctaTyaUutt9IkRncIYAIf6ugnsQK0I57vzegYtX5yx/GH/uR6oiNB9MceDJ5wvpLS+gGFSMoK4uaiMji/BXrVDZM4cnsdhZm3lPg9Jg1c2MFN+t9Ou4VDAuWwktF6f5YImccaKuiuVanzBfDRlHR1VMeDiL48GT5HI8GC6iU3rV4ne2PHxIPrGjvKMIvZtxyVrCAsmVqEe+XG0FhcHDujIIXbMRCfeGsbGvHvwxO56ae9dLecRVcuh1klt7TWgL6Hzl1VkhQIwUeg3OAbxjOZ9RwFgXFkZhRrb8Qbscf26junMEZTHob7N8Qc5IZp2KVdCn6BrHZFyy/MQoLiK/TskRVyhWPsl/eK+MR64XcKazJbwCEWzzogTIV42ZQpu8L5ZhkMYmLgvRSaZ2
 INYN9D+5
 q1/mEzfVfZukVCGmAemRGDgzK7URhT+EOLDS3/GdDRfZkaIwHv+Q+wCxUkJOt39FKRw7HXF/Idg2a6+cIPinpFM7ZgWRiVKkHn+PeU5gHHufhJBrKY0JiBQLFpmJEd2Cda6cYXkf6oW1MabMKtAKd5ok0QjhQ28Ikl+pomog/yUU4NZxzuCQsOnNT04qOuOI7aYfUy7g0T33TnDX1+x4Yih0nIm70wIYtkvo4ythRycAHw/MDNBvzMvDbxpYPInLyg84dWjZCmWWuqUqlmG3AHa51n2sKd4+8xFuupKyBfVxtDjnxS//VLJlN+CWvQ8qMBgWoVvAKjkj/BLq+nlX0a8IsUHAZ6ha9GrM8V2JlXVfolcozhBnAw3Owi4aHAP78zJyIIEmOZ17BHCt6oDemGQl/Fg2r7Txynti7Zr/uVQbucc9x04Am8Hd1CwxPddb8AC/h+VUu46cNDNL/VykTZmBC16hZn7TxoLjP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, Mar 30, 2026 at 03:02:01PM +0800, Miaohe Lin wrote:
[...snip...]
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -941,6 +941,8 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
> >  	if (mapping->a_ops->error_remove_folio) {
> >  		int err = mapping->a_ops->error_remove_folio(mapping, folio);
> >  
> > +		if (err == MF_DELAYED)
> > +			return err;
> 
> Will it be better to add a pr_info here to provide some information for users?
> 
> Thanks.
> .
I think we don't need to add pr_info here; truncate_error_folio() always
leads to action_result, which already logs the recovery status.

Lisa

