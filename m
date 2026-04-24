Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCD3FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F366C6B0093; Fri, 24 Apr 2026 10:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0906B009D; Fri, 24 Apr 2026 10:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD5A6B00A0; Fri, 24 Apr 2026 10:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD7F66B0093
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:09:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79565A0146
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:09:31 +0000 (UTC)
X-FDA: 84693632142.13.B4D5B9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 940DC20018
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:09:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="V3/fDTpX";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/f+isabSkH2QIyE8Uu77GdU/9MKbhz8t7kuG7EhFvlM=;
	b=6KPusL2Qu+NP0s9xRNoxjGI/zgc5f6EfyhuMffydnCJ9Bp/x1AGgwek7J6iRdr9NWSDP5V
	VmeIquefLjcX6oyGz3jLd+BhgiqhIZdFppq/oG7tHKjj5iFNgSYHZcvlKhhucs5bE4WO1c
	W9mSx4E8+Tu5W3w4UDQJjqGcw2Wm8nE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039769; a=rsa-sha256;
	cv=none;
	b=waM6yPToKeRkvkVt+K3DlSX00XoSPLUYzNk7WdTYilGdNnnrfdYwdOrSXZWexl9fCqnuEk
	TmuZ+S5F2ourBKXzz8wFz0LXI45+h0wQDGEYhZ6AIpqdaxEPCQ3AFdWN7RClsWn1Vqnazc
	Q13ZjQphq0wiyS5TUV7ox5viZE2c8sU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="V3/fDTpX";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 931914031D;
	Fri, 24 Apr 2026 14:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E9EC19425;
	Fri, 24 Apr 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777039768;
	bh=mbd7vrxnWFMor772Gp+xjir8bK7BEuVCl/yOKJoCyOc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V3/fDTpXIHmi6gyvZsTXyXtP0jHtyLXYtey52AhNV4m3ZYgYz5+T0QMZJxZtX8bin
	 o72OC9jq3f/RmesTZPnQFhl77OBB2pzpBc0rZvCQKlBUDOGmYBlfeX83L2UF76j6sX
	 YQZQX90Q24SQ3UssBnCPFRSFD4W88puMw1Stv7SE=
Date: Fri, 24 Apr 2026 07:09:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
Message-Id: <20260424070927.1ba82b3ad29de8f85c0e9687@linux-foundation.org>
In-Reply-To: <20260419155540.376847-1-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u5w5sfmbnmzkqzh97fddoijfkenixch6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 940DC20018
X-Rspam-User: 
X-HE-Tag: 1777039769-816375
X-HE-Meta: U2FsdGVkX1+pHGnZxQ2eofgbyVDf9yVOshW9fQYkwG80Pwj6DqPB7h0tnUveUAzCoNaND3O+VjIHSE54/dmw35KithFVF6yDtUzxvUwExPFlIc+ZAYoMDncZRliSE0YZnoib0kX41Tl0y2WZQS5T/NDXdxePsFISxNqyYB3sk46ziknPp88SFwX95DT4vfoZWiXoUy/7goA77ijR+Pam8aTSNy2Dg0DN8vWM5L4l83UC5FAOHM6VFw5gkODIuE5ZRTtmddrdUAMpKlx9FtvyryTdX6KRvERIcffeZjTGHdD1siy9/5iUbwIvyLbXEi5qVYs3odXyeuyp553Ct4tGCLzXDONeJuaHahTIJVgD37DnUpmo/ke+xcavEcw+ENM0HtoFYr9dscnCAvzDDm23OEA+4XSqeLoo0LeKlyDN/sW9feXPhCnLWn9v5nH9Tzi318jCSG2wYp13n73MqMexLJQRZPCXBLT2CDTDKyBUjCgf69yNs+9rif1XSmeRQPWrTefYMmhcouwh3JRIM/2d/dBPqqDu9m2XV2+5ww8jyTxLHPF2rAW6OBPuS/8mTulEau5wYLeclQmiLs3+qmbsgNstt/ix1i6kjiDP0AizjhmhKLEFL7glgowWUYJkesUEUfUnKoY0T4N/X0/RpaQE4GYUrcyYJguvF4al3s8gVQzZDV7EXw8vBYsQWPVJIGYdjVuKgb9d3PmohOMVYrzEn3TNXumbEPSyR+uqgqM0RgFsWNEshQ4pXf1ZLmm3aVpXhYh/Df0vUWCNNQtm3eSFudEl2D0sXbzsNjFroIl4VytNWh9DwKJeT3XxlDbIGm5W7LWhz1YtDSqFZwe1mqgp8r5o3Qp/ztwyI33WI/e+HtJmnZTPieZqKLZaLTRhVCgnx959pd/H/OP6+sE7KJCGme8p/MDF1HJ1Ps0+KmsCD2SxQNLAMlAH/c4kkOcpw6I5KdAEQ/kiWHdtwKSrwcN
 xbuTjo6R
 CfyB+Gdt64GQludwT74zP11xJSq17o+w+nLJgImsnGQwqxeQj7wNwTd/cHS1tt+jN5WrznA1kd+S6jTipLSRm9WH6fph2t9XO4gTmaspUzmDSQ0Fx0OqcD4jWzhqTHyFT0PLWsLV43MrpqqSSZIQTHoV/y46Cvt6qOvsVNLrxhxtsxFDUp1H9heWMIP1X+Mm+rWIZxmZDM6Ejx7hyx6j3W/Q3xAg7YFrZ/c9jMbMUHEYjpkzm85f9D5t1uidXRvDXOYADaVJ+a0r0wYrXqkkY6DPFLUdEcxTaqCoNy4CZ+r0Z0Ug94raQEtu9AZ3FxteY+DYZL4YWT1xUPjgxFrEM7G6JGPK6gI+5fDkr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 23:55:37 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces filtering capabilities to the page_owner
> feature to address storage and performance challenges in production
> environments.

AI review asks some good questions:
	https://sashiko.dev/#/patchset/20260419155540.376847-1-zhen.ni@easystack.cn

(I'd be OK with ignoring the bisection hole issues)

