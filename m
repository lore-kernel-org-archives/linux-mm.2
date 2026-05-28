Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41BCCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A4B6B0005; Thu, 28 May 2026 03:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3FB6B0088; Thu, 28 May 2026 03:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC25B6B008A; Thu, 28 May 2026 03:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 977246B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:06:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37E6FC278E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:06:44 +0000 (UTC)
X-FDA: 84815945928.25.7D2E778
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCA6E40009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:06:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fCfhyOZJ;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=my2xvfOIM0CS3HYizu8JqBpZyrW0PkSKxr4c77D1g00=;
	b=tTNOowa8MiH/ksxUJ69f7N2DNIGa82klyQkfEuRwWye3BJDcB+HSocZQv3cQyl25QCpS+J
	xoKr/TbvdyU49Eubs7OVIH1Yp9rL3VHEcDPaB3kcWe19taqGpWB2kW3hhMku2qirjSquep
	stx96O+agh/LPZYidX02/leYzKyGuYs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fCfhyOZJ;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779952002; a=rsa-sha256;
	cv=none;
	b=HYWQ1vu964CWQxFw8n8AOWMh1rHP3sbWa8XgGVyjuz/a5UESx8sw9867+UpYIjXQHMQvaF
	vEDE2IXyhWqXL/b2dQrlOHP9jzNtBZRTNlohKaNXUXOf99oBylZzl1Qu+pWgKB5oUUM4X/
	Wh1hcEaths2dnld4EWahoNA+eLFP39A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779951994; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=my2xvfOIM0CS3HYizu8JqBpZyrW0PkSKxr4c77D1g00=;
 b=fCfhyOZJmhPOLqzOWpDdiPGbbl0JGQuurLOziqmhfRKrt3ELQzZhRPuGnJpU5EIeTJL5OY
 XlyisbSFtnKO4Qw0T+wL5lcyLeJntfVWXMnOBzWL964v9li/PBxvMwpUG5va0hZEEJhWSi
 a3jqtjH5kxomcovZvmIqcEJndzJAYvGITcd9SjnsyNZbW95dn0ZoyDED3KPSnvg8xFOLzI
 xGs67MSSia9MXOFIn83ODGEauYxfG18XcDOgTqUUEqt2FjG9v78XNjKJlrux/Nei2nDdmH
 aPK868hz/vCxuQsHAj/KUooz3FMeiGzinszQ3JjrbnrUmoiF43kLQhPr4qZkAg==
To: <akpm@linux-foundation.org>
Mime-Version: 1.0
In-Reply-To: <20260527134637.29621cc94aba22eb02f3a544@linux-foundation.org>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a17e978+168784+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Message-Id: <20260528070611.85255-1-lizhe.67@bytedance.com>
References: <20260527134637.29621cc94aba22eb02f3a544@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v3 0/8] mm: speed up ZONE_DEVICE memmap initialization
Date: Thu, 28 May 2026 15:06:11 +0800
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k7oszjpy7woqqzrcbsef176po3abq1cj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BCA6E40009
X-HE-Tag: 1779952001-254220
X-HE-Meta: U2FsdGVkX1+S4cgKaZaVRinWZsutQKSGF+jurNByyvUSIUPw0em1+VD/5aBSQVjWLL6PwaL48ny0poLOlGbHcf4MLZiE0DdyNox46bhkTA83QKerssYyTYjFxeHb1xYTT8tIZqisNhktwf8dD+ueI1bJrn7+GMgF/bUZmYOWysGMRl5Lb1Vjt9Zb9sUAnmt+3jeyUDn7f70uuFPWprBmG3juTFUq/Mo63OCYJPWkca8ixcQAeg4y3Mb7seBNHvywMtUGaT6RSfLXtSbve4B6ixcxDxgohEF7wQl2+wcRtrwdTjG9rmHyVAoDQAqSdu4PWQqEQf0F271mrCNsM6YMHQ4DzQ5w44uqyEaLmKpmfFx3nEnOpxDRLje14CVTie6xGjUtAeR0l8Gmzs4jkLDtwjmKc9PWw5GcZo4orltPCxzZvSHBCMvoZ84Ln9BZNBtfC/rC8P6Zihh0xlBEOq5/ixRzW5efU7gsu3yyU3QNWYYmPFi3bxoh1zbK8roD7e/pJ/o62FEF2PuJmdVgObWeYgL+2W0+v0xx/OuXYK5u3E2ZtzomNZsiSLBH2hvq8PW/bWWwcuYGKcc0E9sWKRwScVniIS9gK27UCZ8/Od0PtX44urnexYEcjxnaQSFk2opEaq8OdO4C4hvgq+1oszVli9jcvhijK+0n+mSEBerLYaMVAJwLcgYNn4lISmrbOhL3gy6baJbYnqY3bvw0sTk6Doa+dZL1p7fZG/MDixQYwUoizCxG+N6KM0zmlPuWu7iOZ7yCQ3oN9LBwTXig3RO4DEbwOwLYTJWI7aQaM8967FjsLTUfIqQUOGBF8i93ZBs7wEkDFUP9IAjsPUVFxG+hqvSQyVVBuIxXP+4sMhmqHmr7C8rBxn4SoxJKjVoDg2cHG8JWqFzpy2rdIzqpW+fmXkkqBgzpBke4sL13czhXULbnjgd8DDUOaKCAaN+pkhY16+PTKdgzllpNo4X/zO9
 f2UyR/um
 fEA8gE0xA0vT0k8/exTnFTZ1KdRDcA9E1NbblVQcRlX/gXVDG1qQrpddFms4C3tTm3h8V5y+jWc+HHEeoPKxDLwqfvqlTI5lIZ4yiAno+Kzj5ej5k7kRJBEWstIiBRu8L67bWz0A+C0gIkHbrT2WmOYTwgdEfvZjtZsHRh7H6+rmTh1W5B9miatCGf1aGPWwDtm7XTBPC+Sgn5GMyPimkHj1IlWF34vA+5h4p0uqEj/dEzmba3/rcNZQw3SzH8bc3HbScyBE8P4AfrtbveMCJD/Ad7g6cECOIGgCdRRkJfM0RbGhn5Y+5e+yLsru7Z9+ZmpDTHSvFMC1bbowDtjB5BIpRhcJowIoX4cXybEKvSjyhA9q/vx18aMK2mdgqxhyxxNZar+ExTzl096my/5wkdaYNT0nDn8G52yN9lGVecsNTPhLZ2yJjUJVMI6IqZuVPTt3r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 13:46:37 -0700, akpm@linux-foundation.org wrote:

> AI review had a number of things to say:
> 	https://sashiko.dev/#/patchset/20260527033636.28231-1-lizhe.67@bytedance.com

Thanks for the review. All four points are valid.

  1. The head-page template setup should not run page initialization and
     refcount helpers on a stack-resident struct page.
  2. The compound-tail template path has the same issue and should avoid
     running compound-tail/refcount setup on a stack object.
  3. The x86 memcpy_streaming() eligibility check is too permissive, so some
     transfers that cannot stay entirely on the non-temporal path may still
     go through memcpy_flushcache().
  4. memcpy_flushcache_small() should reject unsupported sizes before issuing
     any store, otherwise fallback can observe partial writes.

I have prepared corresponding fixups on top of v3.

Thanks,
Zhe

