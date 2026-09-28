Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E3DCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A186D6B008A; Mon, 28 Sep 2026 11:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0446B008C; Mon, 28 Sep 2026 11:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905D26B0092; Mon, 28 Sep 2026 11:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0196B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:46:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02122A0266
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:46:49 +0000 (UTC)
X-FDA: 85263598980.01.52DBC21
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2D5254000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:46:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jGf4hJRi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790610408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7d9v+dnfa33+IGduUY6om25xsOtSS5Ke8pK1c1zkhs=;
	b=SzmImLWrBQYUBSfxkhSyldLrlhLRy6FJbWgVuhFUikeKG4XaXsH+Jp9rEHXtVSLKjM3jDG
	/PteSx6A9oB/s83i5ZcfWPJbdZWj8ju818jb6WzuwnJks5oZcqUGEBmb90eeayvZwygWkK
	zjT1psCgNwlWBKVy20xlDBv94/lkOHM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jGf4hJRi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790610408;
	b=ViFif+2B57WMHoD196t5c1CbrJ74Gln6S4cLMrmmpQ9yKSnk6XnkLNdcWkxXHLrO/b4bYx
	O+yNnbzY/rUCh1yLq5JFyq3LUOJmx/nx3zFBxib+q5K8w2WE/m93+AsCxGfY1DIESkHsA+
	VSZGDZ5IegH+8OllrvySFP4JegYP1pU=
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aa8d882so3376232d50.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790610407; x=1791215207; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L7d9v+dnfa33+IGduUY6om25xsOtSS5Ke8pK1c1zkhs=;
        b=jGf4hJRiFNj4gF4TsRn3tdVKPOsrwXnA+oP1LMDfNmFvw7uX9WswfBWHGx6tl0/FWS
         tWgZmqQNja6EN1eUg35xlByprZnyD/tvX2xMknOu3P6SoCn8xrHDCDwZZiBsS8XZf6HJ
         MYDIDGoZEmzx8GwvAhT2wWAyYjvdhFLDmwSP8wF09og1EAf4UNFzJGP1q9U5i4w8SZNG
         1FAUPHRajdw9mU5mq8AA2GYTrKwBksJoFyymE8xmQ/yWGwBfwi5xwt7SaY/ohTCUJgJx
         rIvLd7MLkihzn/WpLUDc6K3L6nJ/zyXBMKYoGWh/h8mw89rL4Q1rCsRsUSyS4sPyM5Vm
         19Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790610407; x=1791215207;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L7d9v+dnfa33+IGduUY6om25xsOtSS5Ke8pK1c1zkhs=;
        b=Bya5qhZa04FeP1XsGyFpeDPmawjjy+uSnmsvn86F2xy+BEVVrb+KS6wMTpGvONtZ+c
         TI5TCPi17LdY/UPV6BS0eLI04w9NaK8eb4YcwYrLDhF3/BpRgf4Ma92tL+nysS/YBEDM
         /FRquvtRvW3PvdmT348wk2LPoejPYs5aWJwA3wJPvQ/5kYcNNoB+ZRIPmK2Bh3mNcUVd
         kr/93BQ1xtoaEWRQHP+F7jbwXMHRFxkEnruOzHWmM4WR1v9bLOsNp3/QjWcsQrKe9ODF
         wG9YjNFUQmbLW9t5veK+XR5rHmEs57ZLQLUzvUlPN4nPrYTqorpUATyv82TfK8kAL8sQ
         Cr2w==
X-Forwarded-Encrypted: i=1; AKwUvBx0gTBbVMPQI3OR1xoo1UPE/MF96hahAOQ5jtPxV4SWzZnO01JuaDC5M+cxGgaAWu+cU3EYNlAG+w==@kvack.org
X-Gm-Message-State: AFq9FYKdW2V8+Qt7B7CHxxbT57FVxWlfyCCVuva4O2ehtm3TSYEOFxj3
	ooESudopG6Mb/HuVUd0q2HArcbt8e0mVUw70dgY0WuTt99oITnkxv38n9fSk1MaBn0Q=
X-Gm-Gg: AYBFou10XU9KjVfbBrM+efBwAJ+hPJ94YcYZvEo5kaJREUMDXZ3HdNOBOoaE09y9Rs5
	U6A5pdI8zkYH1pOei/lVQfDivJOKMqkHjjs+jFYkDBvLt1o0wIAKgpdSC4Mu/W62G6P85Gu6E8t
	Vs3poLtm+Uuklh2heEoCM7MSiVn8OJJ7EeV+4JFTYG9rpvmGRQJXgfPudUtVm4YfCEK+inave5C
	PQJwt3WFAwRM5mAAK5DOpCR18K1tHyl8XKe7XsYuJR+4K2+MwyvdZEX2F3rISMAWXYiVJhIWt4r
	MnzJNFFM1zQ1dinunfqlNxgICIkNtMx5hxadcCgRp74GBQ6Wv2HLmqmvn8tR7+xAWwf/URKbZNX
	4jEgIBrzIRUIqH+kPYXEYBZHRlUULYwPKeyEoODSYe5cAf+0k2+tC8jng61xa8pX91t9HYtJRBG
	XUsD1KVc1tGCNd09YdWn/xCttmtwKcKBsRYO4hQwTCMfO+9sHAXoXCnAs3+0nUT2OauyAQ1Izq0
	Rfu854g4MbfYXQqD2TvLOiSngi71lj8xtYb
X-Received: by 2002:a05:690e:4093:b0:675:3247:9b40 with SMTP id 956f58d0204a3-6753247a525mr2940923d50.65.1790610407271;
        Mon, 28 Sep 2026 08:46:47 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91430e281a8sm82875936d6.33.2026.09.28.08.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:46:46 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live Update
Date: Mon, 28 Sep 2026 15:46:43 +0000
Message-ID: <179061032462.173069.6066907606098407222.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D5254000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: y5hoojk6wmy33p8fxiw4frm8tuxnh6kk
X-HE-Tag: 1790610408-256035
X-HE-Meta: U2FsdGVkX18tD+hdY6VGL3LC/y2SOlH9tQbkG1j9Hw1fHdcEVc6AoZiDE3dCBYzILHNIfo7Hy6xozcfZOPHRTy84rj5SoWt+Hw9e61qX/prSPUhyZhS+wTzpv+g9+ByPXnVCQCHNi9owcxFWcILn2ZtkCWkH5PL5JPt+gfZPq0NOxZjBx+fR3yNHRmtHGusfnVGSP7Qv4oYgVMVtytEtJbKMA5bxfn/89d8EwugGJckXi98McSpUmnm+oFTAEcX/gSOjTwYWkgsDxfhscNjdNp27QNLerXjnhATjhDb0GKFmuw7sc+21DxoRzU99GAfKUjUeBpEWB1DLczGmHCS+M4n7QA7N3a6SrPulP4Yx0B61V0hfAXyo/glhmHm6fGxmQU/EdU1vWl1LnNU4waDCHS0XWFBzFNaS4v48ZpVulCQlWefCZrvngooEBy8X04i+ICfpwQDzCXiBmFeD/QzImUGQ37aS9UHzBWWLGt9X/Zds7Wud/S+15FukZBzM+xCG+TdOvc5E2YZPWutx2QnkRxCxJiBzgpgRzVbipSxFFQCLCLbhiAWVADRjApdugIm7xi5qDi0Zqabk82DzhgYIU/PjVxywG7L0RRTwNbNBpmDWAAqQ2x28ZehUluVWe61fRQGdAdVJwGBtkzegn2ZfQ01sn1K9IzHFDuj7fKArYzMhEHe2FwxuwZOCeBirW90SlpcQKLpwAAFCdFSWy0Bqb4T8yjSqTWTsU/9yq4D1MjZqnCGPnDd/G7wkgu0hsfBh3HWxMGvbW33dnS3gDdK+OB1p3ELuXbxEPfwgN3gfN+kuDoHr7e8KTB/uhQqpqljzNwf3bNPa+AAmR+xab5dgJgDb/w86VV7/UGTHk8AnI5/obsssI6lnAbkK0aJS4GXpXxy0iA7EbrIIWIyDz1fTkSi2b1NNF/JZg8EXzN4XL9wiuLYUd1bHb/5rgTVpy9fHxHqP87LAANFTS7yWcJ4
 pMItyGgR
 y71B2J6Q+h3z3hQtd3hBizOMPlp0/H16LL1a/Vk1uznAWb+8eq6vyGguvfXxw1ZQY/YYNEwRw5pdVSnWiCBp5KXCPX/iQ0APYgWIVzanw3WFdagrbkbnToOaR8wQUe7okY3e+oOHBMFN4Nw/o065LGne9Z9FFoXQfvmDHMLe4yzREuGwwW02QvDUqSRHPIw58J5TZnTpyoU1DEHUZo9NnXvRvrme7cnLFkxObLk0J72yD0Uc/v0SRcakPH7iIePL2LcENltWvT58s5DF+4N6RsG/hcSmKYXGejAQydXfPjb4CXoUqzUBfHmRxZ6qiHbvnhDxHExAsL8r4MuFqaETkm6+P39OZ/vE/NeefJ9O8M7gg9Mq4eUaomVieGzEUTmhE96Hk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 18 Sep 2026 20:06:26 +0000, David Matlack wrote:
> This series can be found on GitHub:
> 
>   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v9
> 
> This series introduces support in the PCI core for Live Update, enabling
> drivers to preserve PCI devices across a kexec-based kernel update
> without interrupting the device. This functionality is critical for
> minimizing downtime in environments where PCI devices (e.g., those
> assigned to VMs via VFIO) must continue operating or maintain state
> across a host kernel upgrade.
> 
> [...]

Applied, thanks!

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=lu-pci-preservation

[01/13] PCI: liveupdate: Set up FLB handler for the PCI core
        commit: b9affdf3de08c9e5fd8dca0c0bc9c54041362a10
[02/13] PCI: liveupdate: Track outgoing preserved PCI devices
        commit: b7163342c1d4090bdd3eace61580197b2372bd34
[03/13] PCI: liveupdate: Track incoming preserved PCI devices
        commit: 16c1ff9563333530f97888fca4e48548b22ce282
[04/13] PCI: liveupdate: Document driver binding responsibilities
        commit: c7c6bc42b3eebba0562d128b5a578bfbe6a56d31
[05/13] PCI: liveupdate: Auto-preserve upstream bridges across Live Update
        commit: 6f58dec26ea52b6451b3b427caa3326b407883a1
[06/13] PCI: liveupdate: Preserve bus numbers during Live Update
        commit: ec2f2f51120b9461db0e04a7fb1fcdd9747fd96f
[07/13] PCI: Refactor matching logic for pci_dev_acs_ops
        commit: 05d208bda0fd3ef41c3452d1c3f5b365c75b59ae
[08/13] PCI: Save and restore the ACS Control register
        commit: 9f2072fd93310487bf3f51bd61f73ed722be3cc0
[09/13] PCI: liveupdate: Adopt ACS controls in incoming preserved devices
        commit: 16709a37292e480a2d560242d88ba400e0793706
[10/13] PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
        commit: f20575f35fd9ae63f80bc672fc6b31e4de12d4f7
[11/13] PCI: liveupdate: Freeze preservation status during shutdown
        commit: f6590754926ecb0f9119f82a08ef073038ca3293
[12/13] PCI: liveupdate: Do not disable bus mastering on preserved devices during kexec
        commit: 25ff6ea537fa2c1258cb73d57f11d6af51ec7f8c
[13/13] Documentation: PCI: Add documentation for Live Update
        commit: 3b4d450a5bff74e36b4c9e864c0ba7d08288941d

Best regards,
-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

