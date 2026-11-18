Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24B4606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WHXDdl/0
Received: by kanga.kvack.org (Postfix)
	id C6DE86B00EF; Tue, 17 Nov 2026 19:36:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44BC6B05B2; Tue, 17 Nov 2026 19:36:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E1A6B05B3; Tue, 17 Nov 2026 19:36:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91C1B6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:36:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 052241C3F64
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:36:20 +0000 (UTC)
X-FDA: 85446373320.06.846E1E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6733B140002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:36:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WHXDdl/0";
	spf=pass (imf23.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794962178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+p9CWsvki4gFWoEf4phi7R1PRk80mGP3t1GcsR85fk=;
	b=QuGIPJaW1AyajkLwNJbSwSiK7hPqQAcD8SODfXo7ti823f7qPkqqHgpprAoO9d69s9/Z/H
	f18hBjtjIk8VmVXS80e4jsdKXxtYBRC6KkDr1dZklo3H75gNix7Ji45Jcyu6yd0xYNi7iB
	RejSviqeF0miNpzvjC2Wyd4ycoFrzso=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794962178;
	b=nzl1WPu7ErWi5G00LyvLG/HoGnqtvxxRG/gDH/BXTKOPdhM3mRLu0ebxXOXZcJrFJcP1Es
	6r3U7MYQfUQw5dc991k70jd3fe8FQSJwiuIj/yHCrfWVDQikFGjXzj5HWcAnIFEFtCYGEN
	bpPYCXf2DWU/dI0aeWCZ7cggc68e6Xg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WHXDdl/0";
	spf=pass (imf23.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93AE8459CC;
	Wed, 18 Nov 2026 00:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C80A1F000C9;
	Wed, 18 Nov 2026 00:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794962177;
	bh=r+p9CWsvki4gFWoEf4phi7R1PRk80mGP3t1GcsR85fk=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=WHXDdl/0EiLouLi+MGg08FvcqvqZP4js9AonYgqIzmzUe3K/XuplULWC+xJEwPygQ
	 QvifdtnAJEtyI6bcM9i72IshrE2dTnaDjFtXILMkioUxqh+f45QAshi8Z3DjjBsS3o
	 /pgvgpWi03BU4s0zfUOfHdvD0jWrMamvbKv7JcqCWcyu6vSEijFi+GZqVomEz78pDf
	 AwqF33in7XSuZ3WuM3378SNDogiZPh/C5JYmA5NqvB01j+9o/WBuWB0AXyidZTYGOc
	 8cx6E9Gnz+1UJyi2z6K1EMYCF+yHZX5pPbCDgzuZIGnN6blT2SXTSoq+KdCmVRYWu2
	 34ueIPw6CLNFA==
Date: Tue, 17 Nov 2026 17:36:15 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>, rppt@kernel.org
cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, 
    pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, 
    shuah@kernel.org, guoren@kernel.org, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    linux-kselftest@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v3 1/4] riscv: Call early_ioremap_setup() before parsing
 the DTB
In-Reply-To: <20261106071459.2003-2-cp0613@linux.alibaba.com>
Message-ID: <68812baf-206e-4916-faa6-78f8e7fa4433@kernel.org>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com> <20261106071459.2003-2-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6733B140002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: cz5cuu1fzo3arjow3pqh9qfe3iutf6dk
X-HE-Tag: 1794962178-696448
X-HE-Meta: U2FsdGVkX19btqIEJT0gMJqOR4CxZIOgj4rZqyp7NPUDWbYU1gTYk8FzqSyObo3vgFu4PlCJtpV+5ikVtDgo0f/dFGYJVZcK32AlWZ0atjF+k7MBYVddZGZpOl8ixV/YoKszgeg/Z0pfEzd01CeJiRU8qwaqKnQyUwmlUpCCUiR9cbIHSNaqywhVCjBPGHJwXM2U6ckqAUIcnxPoRE5DRCqwVC5d38pcJI1kRvwFMsyaLUt0UMOLKrUiSyT8c5ZpbWS2bqB2j+Yj0Vv+29fQh2CzBmSp7Hx2nEjea7MZWoj1iBpzOedLn0Pm2l07O1fJF0PvNxoWhw3PccSxxo94AvxWg5/HtaQKaJQIcIrTLEjGtkfexSBrh7Sl+p2ISRQ7gQZdKEVGZDSkkrvZnpUoseaYE1oRSTbLsBC8RzmF28CSJCLiFZU8QlQD6Bgf3cSDd60ssKth3TRgYPswR4yl8ZgF+gWKQNa9nYkNhDXCSQp5gumV5mEZrUl9AzLHWU/lODTFLpXUzKaEVupYoTh3vjt06+BIwl0E4xSEpH2XvkTSneAkYsiz1zGFhsk2cOFYNkMQ0HiTW1xFYRL24L7ow8UTyfISnhT6pVL5mkZo96Zg6uf51w0+OR7z2eUq/G/L6KUcL0XWPP28NIrrUrb4n3EoKRHCmN/IXw0/92250z9ExbbdUKr9Ik8UFnVLH6B3ryjUFNMwU1iPaJ2MUfrrW0d0IwK+6/XKINQLI77PCP1rKyxg0H1JFXVyJOJvtprDDtOSLAr9ECSoSenu+8mSjXdyn3JeFgG59bDbOUp+GjJZrHVlIY3WoTuHPCnsh7v2VFwcugPt3ALcyOYLCTJARmSmpveSYEIyalnSQWjpUBaMsD6C0xSDR7EXVnE9sq7TSLbbrUYMS/708mG5dvbkifGwyi3t+4cyDQQJUA+IC+7Q/pO1J0UnFqQSe4OX63Wr5rIJBVPuZpIAYtX0wj7
 nwkJomHR
 IthSkLTdYZ46DhPLTlOKBvltnqXIG8MBJo0kRRHPz73hXqLMEeeIb28AOK8jY63iDpv6W3eDd6hzln7TtCy08mZZcoMImAXTi0KeV8qBkx4cBiPVUKzSnX8jBzgNUcTehzh4jgZCHtorCKxBrSgZFFslxcjonDG+USOEWRjZbgyaLuA20GxTx/CZCk6l/rPFdp+UJUxk8/vxNMNEFW6pI0gs+GNYtHbgYeNYIiT2UKrNMeD0IFWayaamOAB0oph+pJHcen58WqWRoghe0+aQKmPS+MB2hZqqTSc0qbgajCSsnoYnRi0MS9ZUatb4LqxeALQLD/Keu3H9IV8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike and Chen Pei,

On Fri, 6 Nov 2026, Chen Pei wrote:

> parse_dtb() can reach early_memremap(), whose return value is composed
> from the slot table that early_ioremap_setup() fills in - and on RISC-V
> that setup ran after the scan, so the mapping came back NULL. The DT
> based kexec handover parsing is the first caller to hit this:
> kho_populate() cannot map the handover FDT and the handover is dropped.

This makes sense, but ...

> Run early_ioremap_setup() before parse_dtb(), as arm64 and x86 already
> do.

... this statement isn't right, since neither ARM64 nor x86 have a 
parse_dtb() function.  Better just to say that early_ioremap_setup() needs 
to run before DT parsing.

With that fixed, then 

Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv


- Paul

