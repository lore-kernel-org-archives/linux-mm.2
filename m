Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F80AC44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9756B008A; Thu,  9 Jul 2026 06:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192BC6B008C; Thu,  9 Jul 2026 06:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE496B0092; Thu,  9 Jul 2026 06:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBB756B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:13:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7867D1C3974
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:13:53 +0000 (UTC)
X-FDA: 84968827146.10.5EDE002
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D37D120002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:13:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lrBFGv8V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783592031;
	b=YTcaWoKCFYakqR37aUVpoPYBk/it/xMCvJWvpvbSwieVFlME7VPpfMrDUbSAmOgIewKTG9
	uVerJb3aMFoexvD7jYTTu4zVLh1DAasGz/6nayvU6BPT2l3R7jZ7tXKF2josmO/7qYGI7I
	qWnK8dQkPHviW4/bBxupplGJCX2+kxc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lrBFGv8V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783592031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SD0aIjHfaoggg2DHMtCVeGQS6uHDWHhpooQxVPGpCE=;
	b=K+nJqQkaWl+cqVeypHbDkCJ0xR5WurMCqh0wmyB9khw75oOm+XLWenQyGGiAIKdh8SFCQb
	fww+ZkQ0pnwkz+8djNjI7k5RMMYQlwo40nj/Gj+96pKV3KL3skQAHgxQgrx2e63kJEfoRT
	tQc2TpfmE8qfl84dlsuw/sSLzMecYmw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783592031; x=1815128031;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OeLhPzcVXF6fMNcUxkfP3OhDENjij8/DJ/G3glukAhs=;
  b=lrBFGv8VjDnbHLkUD5cqjfftgeZ3Ua76i3U1Or5Ig+DBs8w6ctxVVFpV
   SvSsQpq+OMau9CqSXgkM5YFpRFR3/WIxlKDi9SWFyOvxKoy+kAzMs8/39
   FFuRFSL9if+mSCk3g5hf3fqdo4vMsPv2x6oKsozCRVLb9TAeoyVTEmGAB
   hncXSOdsQeu6EtAn1hDPjzA/UFLRJwhYzJu/bk3viCG/Ytf+4pjNHgMfU
   cKk6tvlYH9WGj/cT/3yoq6uY1ZIgE9SEGYMfmjb8KAPNLt8dzRZ72a+kg
   07ELyfeL/83KfJceWCAP1JQXAQ+SoleB1CV5lN9u7c+PTyD7aZrHBjAGD
   A==;
X-CSE-ConnectionGUID: BFCIT6W0QFCEy8toAZvXwQ==
X-CSE-MsgGUID: qwbYsjhaSrma0RxQoYIDSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71788849"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71788849"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:13:50 -0700
X-CSE-ConnectionGUID: QTwbgGMbTmmZDVIrRcAORA==
X-CSE-MsgGUID: LwqxtaTVR0a5xklQA1djQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258850037"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.235])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:13:47 -0700
Date: Thu, 9 Jul 2026 13:13:45 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
	ryan.roberts@arm.com, "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <ak90WW3I4tmg7Pwz@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
 <ak9mrw37kTORZXmc@pathway.suse.cz>
 <ak9z3ZRdRqGoOu-T@ashevche-desk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9z3ZRdRqGoOu-T@ashevche-desk.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 1D37D120002
X-Rspam-User: 
X-Stat-Signature: xyw54gcb5x5r8fydwizgjw9nxdq3pcyw
X-Rspamd-Server: rspam03
X-HE-Tag: 1783592030-86846
X-HE-Meta: U2FsdGVkX19k78+f7W/U4AVHkG4ErG64dZT1XS3g3q0D9EkujD8pTqVd10m7BxCGnNNLK5QM2qxkQVgBtKGh2Chh2exyay6qVpjk+xdNAlR7iRWhN+etvyEW1OH5MTqYEm9Ofw2qAe6j+9Cal1HvERhYzf1UTFjFcobpI2Pbx9nNp9/lMaHyJ63ypymEglY7UMo4LKmi+0TSmEwoe6GHmpNQ9eOPYkO9J6CmX4TFty8FPJQf2u8/LfZcutfEF+RSgfU2AcFT/CAMTqvo94K0CCvzAZmToDqWP2xgZrTNVBtMMZMzqcOLli/1IADxlnrdbH9D8sN5ziblZolOGCDVf9SHfoUT4g/vg7802A6VSLpHcRicbXVJUGsR3dYxPjgiA5uwBT7/nWxLlYyajrEUNLbbcQEQEeDV98XaxHTWlyeqoQZHDCi3ZxxAVei+Ip5FGOYlKTdSOAcYYzXMFByXMx72Qc0yzfLZsdsWRHtoMkrj7TUF4QrbGwZDYDjX3L3JBhSgtLOaO/Rw+OpW8wp//wxVAiLfxhia7YVPFPu31zWMMx0nNyXYAJBwRWhX5+5v9dBzEYUKey5hyGp9+mVbPv0ig78rSFHokyKbZ8vhKkucEYIOSyMIsceYed6OvYxH5Rc11iJbxJNwV8PTr5rCp/AMrjul7HcpSkAnyMl+ZCepQjp/AcxCYaYQruPAGZDT+SsX67cz+px83+FP/nRL56bcqGzkfCmZ2797e1jcnyG1y+8ZFRJloO0BCxC0u4/5PzMJSPMbHxf7yMcao30VYg+vIx4rdn+us0CTZSFq3JmaeZiWr0wpy2Ckm4v15rPDUoy74unCgwXbCcYVhmZbogkHVGO0BlALx0I8KilSprRGKjyBmazOKk67iXMAJoxsSOY3S7ql0+5YJ2OVjOsDglhC2krDjmRDEs1D/iv5hX/uTK7SewDvnxV9/kkMl42TloVPd3U0y2ukkKLj1HL
 VIwN2CzX
 lcCOrL+yV2gRfToy5oSHa4+eVB0BZyeBpdF6N797qNopUwBRFy3FTloDBlGGjnO72pBl/eKP2XXWvJ9AxdVQPl4bMauVKToeMaNR98AImH0i2mRPNYS5/NiS+kAimiRYSHegYTzq3TTo/Terj3MAVGsCVSFz2Dd+ZyIGJMcaHl9ZYjR3S4oJ0xbQIF2ReAGQKhshg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 01:11:46PM +0300, Andy Shevchenko wrote:
> On Thu, Jul 09, 2026 at 11:15:27AM +0200, Petr Mladek wrote:
> > On Thu 2026-07-09 10:40:43, Andy Shevchenko wrote:
> > > On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:

...

> > But maybe you had something particular in mind.
> 
> Yes, I was thinking of a wrapper on top of special_hex_number(). It takes size
> as an argument and hence will work even for 128-bit cases.

Okay, the argument is limited to 64-bit in there. But I don't think it's a big
impediment.

-- 
With Best Regards,
Andy Shevchenko



