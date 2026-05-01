Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D81BCD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 00:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28AF46B0088; Thu, 30 Apr 2026 20:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BCA6B008A; Thu, 30 Apr 2026 20:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151CC6B008C; Thu, 30 Apr 2026 20:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 040046B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:13:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A99731C0094
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:13:06 +0000 (UTC)
X-FDA: 84716925972.07.F45B49D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EB535140005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:13:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hmms8TA6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777594385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A03yx1rz/5y51k7Kswo/ow2V5uuxjjCYl8YCI+hDwJw=;
	b=Nb4wLoECFp1LAmEjTceAdIO+sTRTkHtrpKksfYacwDg6j9Z9fFUCsV7wWqsBXLiJC67utN
	3SrZcpXRhYQ/bKi0PUJkSMyrQKNLfgEUwOYB8Z4Esjj4YoY1QNIDn2V64zzEni3Vf/Xa9f
	EuUvHapFYFq0Dc12CW1RYdfAbDzJTX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777594385; a=rsa-sha256;
	cv=none;
	b=pmdZqmtLVRARho6pOmUs6Qs+ngMBdCDnK4ZAv2DsVc8x2bqSMbJ7QJhTdcD2yeYAfeUjSy
	At5TdkOybW0Em3hSXsSGL1L1M1fnyEATwPGrEdLeDLbkR7FSdV8PdXyY9S1Nls276f7QVI
	e+qHCGzxeNpryaNhP2Bzi2vBKW5+6T4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hmms8TA6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F5AD43647;
	Fri,  1 May 2026 00:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAB2C2BCB3;
	Fri,  1 May 2026 00:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777594383;
	bh=C9zRzHlBN3lCki8WwM8Uc+Il8Hn7Oml0wIHYgneWkGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmms8TA6MgHt3kUTpdk9IH/TtsBz6BdcH3RB2UYyiPpT/6JQ7gVQKmSw+D5VT7Crb
	 Jlw6dyzXeEEDaVVKaDPcBlCVbgqPb9nZyU2zHd0Qkh+a2CpJ7zLYYnZW3gmty6KobX
	 GQtaQA7IQ7qLbBWrEscSKIMsZJJ9EtJsfYHgr4rIkuZyBK9gXVn2wf0B7+WkZ/kiH1
	 EjePGxX5EydkwXFA7erbI3PyVaSpmdRCXdJT1Snx9PlDMqhTrtXX39uXGwqUFjx/Fq
	 zSOTdaM4vtO5qh9dGLPZsFpouLPYWXz86zLcsARsIcvAGxcxRZ4ATsBEU3/NQpWzQ5
	 HcHJCsP9V4DaA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Zhen Ni <zhen.ni@easystack.cn>,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] mm/page_owner: add filter infrastructure for print_mode and NUMA filtering
Date: Thu, 30 Apr 2026 17:12:54 -0700
Message-ID: <20260501001254.77598-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430112245.be3189f09bd6a71970a74746@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB535140005
X-Stat-Signature: ojqzocyqqdy4f4o3yt4msbt8uu3gqtdf
X-Rspam-User: 
X-HE-Tag: 1777594384-772371
X-HE-Meta: U2FsdGVkX1/IEG/UMCY0Ud2k9acJtNYCHYPvpXodoL+/2uT+0c6tCxkegE9KJZRCTM9dRj9KPu1vcnmPJVajXMf8Rpn8zAX34rc/bLnOQSq+/QrNai5Wk9OStfc5QTWzfSmxIfeNcWWwlXWgdPYmbKE3Lu0kUKBLnEal2nZcI6ggwrD5UY41CoVoleQE+mkJrhPdYf4WoHZJBeCviOkOsATGdHXLTYJ0gpIJAS2nM0a/9iQ++78NCsCVHRiE/U2Vl3J13XfetJCLej6unTaEubNbVT++EZe9w8OUxsgWau5K9ymTIXcQkN0KSVupRTmxmRhhxRD+Uy3LS4aerrt1ZNr84mrz8KPH+FoU6FiVLbR05Pc3q96fNJ1S2ar7EnP0Fbuc2PE2BsjlOkcstyH2PmT9P9+syGvyOWqHJ3IDICLW1RjFgCpzxrPc7L+sGi81Y4wuMyp+SMg3330qNwmcD66rzJPlThvJ3oUer3ueLtv954lST045aVj2fK//hsiNM/WxPoxH6F62zuwXR3zMM/zFodK9vuf9vlH3VD3FaUr7dzy3qlbATCSDYHrfPag/nnXtthbW8P6biOL3epxeKmVRvrmvZMYNi1oJKYrZfLf2HvPn8dwQPP2BBXdmb3vmAs6s+bC/i+EVIyV2RgdinwJlMRIIJRnVyXjiaSoQUIkJRsJMzjCUB4W6mdTbeD9SLgN45+Gp3iTVnJXyfyTx0vvGbfUYLmgQbW2YPCAV/BCDzmdacBHJh1fzxEzWFTUe1/dV1Vwtd7GcU6J1okYSnRBd79RlCIKI/fJTihI05T7OM42o5m1ldJatd8Nmf0g8V84uSHtQSCms4wVFP6LU3b8FC7GB1/HSFWn39mLKS5jMsCCs+qjPlYGJPW6W521sbVVx9GOODVCljDPjVPUFLMRPDjY8Tf63bb50fD8nQaKVvg3l4hXSl/BCzlJIxcV0SRbCcxIUKWdYoEcJnRy
 w4IQgmev
 TeZTP+ol5XnATxIcXFv+f7nn2fwFhIq3MrUyUgIVLIdyjJaXFWJXjADSdsZ42wPsq06U9fywfOG9LLlK3PHDLcaGfsd1z8d5qwKh0XYrCLMcyDzO+wFHOS2eyaLpiXRuADwbpbzuGGOePsoIJ4CfatgxRhVV4G/HGLNeM/ZW6s/M0YCW9fLbrDfsblhenbrJAcpwPl7+S2klvzHpKzaya5wgY5x/8lEr+zefiTv8fPOktG+2Z3Fv4liz4dmO4AnWu5B3Wm5wrysFPKDh9bsBv7LSQRcUKeHHEOWJejWWMUFM5i96dMEWE79FG6E9LsJZE37Y8Vy+UcVRjIOBsfIBQfKdEkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 11:22:45 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri,  1 May 2026 00:32:44 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
> > This patch series introduces filtering capabilities to the page_owner
> > feature to address storage and performance challenges in production
> > environments.
> 
> AI review asks a couple of reasonable-sounding questions:
> 	https://sashiko.dev/#/patchset/20260430163247.13628-1-zhen.ni@easystack.cn

I like the idea of this series and therefore willing to help reviewing.  I
therefore added a few comments to the previous version of this series.  But
unfortunately not that much to open the web browser for revewing the Sashiko
review on my own.  I might willing to do that on my onw, if I could read that
on this email list.  But that's not the case and I'm a lazy and bad reviewer...

Even if Zhen replies with his opinion saying Sashiko's review found no real
issue, if it doesn't have reasonable amount of explanation with original
Sashiko review quotes, I might still feel like I may better to double check
Zhen's opinion, but again I might not feel like to open web browser to read
origianl Sashiko review.

So I will hold reviewing this series until I sure the Sashiko reviews found no
blocker, or I forget the fact that there were concerning Sashiko reviews to
this series.  Just wanted to make clear why I don't keep reviewing this series,
FWIW.


Thanks,
SJ

