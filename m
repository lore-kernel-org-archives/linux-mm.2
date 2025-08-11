Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA079C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686128E005D; Mon, 11 Aug 2025 10:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F678E0045; Mon, 11 Aug 2025 10:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C848E005D; Mon, 11 Aug 2025 10:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40C798E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:34:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE3E556E23
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:34:19 +0000 (UTC)
X-FDA: 83764721838.16.8015029
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0C3BA2000E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:34:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ifW0svrl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3Z_-ZaAYKCBoI40D926EE6B4.2ECB8DKN-CCAL02A.EH6@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Z_-ZaAYKCBoI40D926EE6B4.2ECB8DKN-CCAL02A.EH6@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754922858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3QC/DofyyJ1kIbquP7TygGRJBogDIdpEUbLnTdcdHg=;
	b=d61vhAy00XyLwd++tBLCSH9EodcnUArPAaueEgScQogSRwlIvukDhBrwjwFT3D+fNCwivR
	3gkAdVFJipKoohpqZVWTGEK8Pv22mPFw0oNFe6lhuycPyv17PdLMH18boSuAiqZSVeXMyt
	tEojN/UBOvQ/Dty2UNQfOFEL21wgJss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754922858; a=rsa-sha256;
	cv=none;
	b=C7VwYyK+cAhl3Irq0iquT1l+90BFPo4c6H0IF3vdO+XVYMxayKVF5LaUJOE5wwhD8vbS0L
	wIfncfjlIOKyOv1qn6VgLKKLOOLgPMW72IyY78IM5DPP6taR3/VTCqRX7+0G2V08vNdEJ3
	SlhM+AHP5/qS6241GPCWMHztIUkEeB4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ifW0svrl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3Z_-ZaAYKCBoI40D926EE6B4.2ECB8DKN-CCAL02A.EH6@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Z_-ZaAYKCBoI40D926EE6B4.2ECB8DKN-CCAL02A.EH6@flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4310451ae4so5560788a12.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754922857; x=1755527657; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s3QC/DofyyJ1kIbquP7TygGRJBogDIdpEUbLnTdcdHg=;
        b=ifW0svrl2EaUTAdYg/EyKknsd7A+3Nmaa7r4r9404SoC3iPjj6E4jdLVzypBNpfssb
         2eVQpPV+UiZaODlmEwNejMGR21FSYMHldVD5hHvviOzNOfjhKyDEx6ogJw1n3mazThrR
         0/MVR17jyfHdvI3uVUVWPtC4gIQWEKOZj+rppqLEOE0CMspKU2OKXnEi1ObbKb3r843Y
         QED3PMyr4R3KKZHAbwa9xcQcSiCcOmxm5fTGJ7m3At6tNGWdeAPmOXqMU5aoS5g5izGz
         9B4WTzOHjEtPDRyorJDB1p5gJvfkstJ0Xbw8PN6wzY8lihc2+0YlEpSEfoVhHZw3iTw0
         74dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754922857; x=1755527657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s3QC/DofyyJ1kIbquP7TygGRJBogDIdpEUbLnTdcdHg=;
        b=knrXrDt9F+UsvREoY1aa6PxJ0qpeqHdiGLc4Gdl/jcsvnU/IS0armX0np0pGemG1Ld
         31Zg4w73AVoY79FBbE+i5wwVuNDpPu3eT92Tcee7RWYkYp+1MLNYcK+Nr1kw9crh1Ojc
         2GI+ICIJRn81sIPsAFnsiahEubGoaeFuXh01abF7EsiAd1DyOaT55ant5t8UakZubG19
         ceBKZiLj0x2H+tx+DiGftTdYJwP0eB6jRA1VmyAyr9rN6pxx/i4ug86FRonMWx6PLg+G
         OVjQoeF/5GkgNM1Zh3Y64lFgvvqVAVdQbFch8/QD6XbXFVAmfz6XTb/XlTtM/Ul3T4bm
         db9g==
X-Forwarded-Encrypted: i=1; AJvYcCUBQPsZJd95pNwIxJlHYEZ/H9xLBmWNLV7OK1yp5IuabGsbASVt79/fdd4h1qiFfu4JFHLQO537oA==@kvack.org
X-Gm-Message-State: AOJu0Yz6xel2tfG65om/5wkFBtjnjRYn720YLJ/Pp5hgBbK3gV33wIVA
	0PB56zCGN8uzolf2af8RSzh8uuoVtqOSNcwGqtCUXK+boRKZtFemY1fYWNcSEOQBdfc/QO8Fw3S
	xL0Ba4Q==
X-Google-Smtp-Source: AGHT+IHDzFt+0zXjA0CUz3si8YkwDTRVPFUsiiRh4VZN4Dkprgq2wlq3CPL9ofZgO6/62HnwUQZt6ujhFVk=
X-Received: from pgos21.prod.google.com ([2002:a63:af55:0:b0:b31:d198:ffb2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d8b:b0:240:6dc:9164
 with SMTP id adf61e73a8af0-2405502ffeamr23223057637.15.1754922855887; Mon, 11
 Aug 2025 07:34:15 -0700 (PDT)
Date: Mon, 11 Aug 2025 07:34:14 -0700
In-Reply-To: <20250811090605.16057-2-shivankg@amd.com>
Mime-Version: 1.0
References: <20250811090605.16057-2-shivankg@amd.com>
Message-ID: <aJn_ZvD2AfZBX4Ox@google.com>
Subject: Re: [PATCH RFC V10 0/7] Add NUMA mempolicy support for KVM guest-memfd
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: david@redhat.com, vbabka@suse.cz, willy@infradead.org, 
	akpm@linux-foundation.org, shuah@kernel.org, pbonzini@redhat.com, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, ackerleytng@google.com, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, 
	bfoster@redhat.com, tabba@google.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: gqxayg63r8mc3ayfi7x3q7kq1bmm6qwq
X-Rspamd-Queue-Id: 0C3BA2000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754922857-511953
X-HE-Meta: U2FsdGVkX1/Go6hJODQYIeLJqG+fCHZTSX2Jlz5idWwuUUQwcLKV2k93L+dd6Z0hbNusyPxZVbB7wjrKGkqG+3mV9H0uN2/ulv3S8AG+ZRr+8O8R82qsZVNUHXbEBFZ5FEyUMnYk+IfCNPnIkUVdOQsG4oxWHJ25fQG5FbVm1ZwYtg1KQAyrVI3P4DbA4+gh0KVRJxiZCxQrW+QV79Roh5r/pt2nKXDJsadkNCTIk95IIcqsNeS6cq1xRFiSF0Dx97mQWx4tfq37BzZkNjSApLALnCtJbWSo5XNcor2+rzpybumUnHaD+PvAg8jNTLBcmmLE6Mn6AH3JkT7Wi/9OLCUtOmuaVPit+lzFi/EGYA2Z3XGHCgxxLfvSR4grsfYvaaOtu17BgDwMEFFH+TS4bm84NP1c4AAYoxYluIvovUuxuL1tcOuioW7lS2Beeg8pzHZPAwf+N/HC2r60A9hrMVAvysWnD3+dLmcP7b9drh1lJIOm6pmTmwwVV4XbrCmmAVpQcRFRyQm7X4rg2aAnWeeIbiXe0DCYEsHTevcIxoem7Feb48vdMnJLg0Lixwvt8XUBaA+nO4eioHjJB0Qqm+zeyEEY7+hgQ4KFznT+pJ2SJ/EAVH/gZp3JvtQviEGjL3c2R+vGxg5qfeNdWE6ztzoTfE4yjrmW6+QQIU/KgF2fF75TUy+YZNAog+lZRxnqFZBRKw25EGlyJpmjadrknp2G4KV4rjDeIorlol/iXADnDWnIiv81yoI0C0kLP1ZlBVSaNED0U0rvgWNPg+5pMFInuoV2SY3MsO7CwJj/r0m009U1KA96XC/MVkioxbUwNHaXwaZckRTcPn/z7aPw3fR5MXhy9xvjvEVmlFCp+MmH3+RHzhZEX/JPBpn8fhmLfMFQd/gSZrt+dbBp0ylqbyNsGV7cM5y5ovMiR854Uqa4uQu6U+20GX2K6k6qTQE6SXt9xqiFJgo3Lf/fEy9
 J8TJRoGJ
 Ozqm8HXUlKDWKAmA69Mf6M7vNI0bb7bWVUZg/99f/vLKBAuGOL8OrKP/03i+h4cRmkPwo6kfFZwVy+0dJMMLaJYCN6h5JDvdsp0J7jkEK1CsucH/tcsKNCm6voACNqTUls/M1qZHf+lu4a0A6I/JmzbxFMHwCls7SybPhtZqiVBk30N5wwFCsFPWK4ALjSB/Fhekw2+GXIzMkDuwV+6buHL6uL1GVo/e2B8GHj0AvWBMKQOxhasNNoEdr9zFcXQA0B/YCON3Gbb1fmdC94hrGp7ghIlhp02YWv5Y0FDJfFMV9fROAQ+BSvWLVy13bBkpn/wJYM32wFk4QVZhnsuWI9QncUauj+VjJJiAEQPRKAbrNEEFiMsldH8vX228xSpkm1iGRMGpH9C+hbmprC61jqZ+aZ6cIcQ8rvFOoAbnQ3BPCIy5ZMeF+RoEQ6qiG1hCx/Zxod8rwmyLXm1Sr0Z4yn6jLEKAwgFtdWj850QFl5JRvaR7UW4uiDa9z7zkig1Fk0Dj7kOfzg8bBzrVyHey60hnxPEp6g2EIsTR49VxZmlcbhiKh+bDERLxPJE+omYbtpPnEnI6g4jrqfdf/8kg7XwrR8pK5qByi/iU7rtVq9/m9pqj9j96bpJMgDH/TI4xkEQtzKFhDmOciB7MmtAlFWvb9hT2udcXYw8CM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025, Shivank Garg wrote:
> This series introduces NUMA-aware memory placement support for KVM guests
> with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
> that enabled host-mapping for guest_memfd memory [1].

Is this still actually an RFC?  If so, why?  If not, drop tag on the next version
(if one is needed/sent).

