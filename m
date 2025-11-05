Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B5B3CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 15:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776628E000C; Wed,  5 Nov 2025 10:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726CA8E0005; Wed,  5 Nov 2025 10:57:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641B58E000C; Wed,  5 Nov 2025 10:57:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 539478E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:57:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2F0112C1B9
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:57:53 +0000 (UTC)
X-FDA: 84077009226.12.FCA5C47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A0FC1C0004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:57:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oICOgyYK;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762358272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2Mm0MsrMQG2Og7FMXueo+n8c9h6gOgi1Q8m4UCT67k=;
	b=gUH0EnB9V6irJX/iSmCYiXuvIKEfYOWymr5t0WE5ZLdM5tdDLyi2B0rhs7pX6kP3yX1Lsa
	Twbn9XNBMhcmEKRoIe9OfFCWaOQLfxaNlFhOoxONsFHnar3w43pE9KDOH+yny7gI/Rq50C
	lysq1iwiwOrFcGhQ2Ijqj+6kMaBwVCY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oICOgyYK;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762358272; a=rsa-sha256;
	cv=none;
	b=4ftbdWhQqmQEBaAsS1vR40aFa6tre8SBypyinMSiLN81hwnNC4+QPu9unpSgwOjb7DMcP8
	OhPP+bXK3LjX7x6enpI49FG44+edKp2qpQQPQMAGAyZSBgDWl6oegl1BQZBterQ8gMU1dx
	MKK8s93CP0AfwHfV3PU+DR92tcPxKyE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AFF6446E4;
	Wed,  5 Nov 2025 15:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626DAC4CEF5;
	Wed,  5 Nov 2025 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762358270;
	bh=QE/o0Mh+dZdKXtnvDA4J2WYsUMjW6VDyfclBimdmgSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oICOgyYKQxTIre82iUXxYQa+v511n78p0LH/55yOrC/qPcixKX87gwddDj+41MvaU
	 udDR3K3EBQpgaowODsG18JDcxc/9Tm00bcjPVXc3wnknNjtgfgAbq406aWeHYZjI5z
	 4uu77joC5oJffXn+3DZusDdh4FUBNZjP+i+b3b0F4GSCsrwLEaBgWDor4d6LqO/29r
	 Pv3KNro8m3YZiHAE2j4eVhzRxEZTXzdKwYbom7E6szRwPYBQga2bH0zXkFLHi9b4jL
	 AJ2ZrrbUyJI3JInBqsQp2I7DwoEBzEHAGOgWbygjatGbYoaDoSc1t79LMgiLlaLprW
	 4ShYMDmkm4j5A==
Date: Wed, 5 Nov 2025 16:57:48 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Phil Auld <pauld@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Message-ID: <aQtz_ODTgiCGS_oB@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-14-frederic@kernel.org>
 <20251031125951.GA430420@pauld.westford.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251031125951.GA430420@pauld.westford.csb>
X-Rspamd-Queue-Id: 0A0FC1C0004
X-Stat-Signature: enz7digzn5up99c5oj5re3x76q9pfsyn
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762358271-103673
X-HE-Meta: U2FsdGVkX193UbK/utiWbgu4DzLaLQjOXr9QvruPlYvGo0VmegpdfZkBaHsnj2GRqrRmsKa/Lb1zhXyBOPn7xjcG27vV4egR+RqSxgwjGAgf5g6rfaEuOTj0lBBtHWMyFRylvJUFKs3f56mDAohgtf6LhETh0ZTDKLVcePCS5Rgy9mcJo82RlHrC5jqXhmKZ83W1+ZLoJAh96MY29s4LMb3Pol84+j6TQ7XN2qvuYzMdoCC9ILHtf36M4xGjeKHrJ1aAxoVz4c+MVSNrwXAYSOjES5tNdGiiF3NOtvnJVgCUHz2bcuUUdYBC/vJtI3hHn3RPZviKWseL8uU8lNZXcHtVaBBN0nOzh0R1ASx8YYufNzttPFDjAnHHRh22Eg8BGCx2w+L93B4OWWIe461tZaHt7AQgZD4WMXys4l4mHczhg1s0un+R7VtXkudgWVk2M8VTV3fOnkKe6eCeRUIV7AWSZ1XAh5TIu9qsUIEeoJWDHsFYqKZDtEnl6brTZVN2/lxB9l7nIq/sAHM2utdANfVqh/0PAkjs5iTl2XYG1HhuSN2f7NvIS05s4zuMMi2+eqtnaU+t29Us9lMdl37NfWuxTe4M100rb7+EpAkSU62yF0aTbAlKdUQIZblOSZeZijKe3bezdIsQkJC8pct2AMDzx1PSMnwKU9/481XFMoDTjFl0uB8FZBsGCjHZ+h1Z5OmIUyTpO/+gr9C9FzpocwiLEkX0LtyEt1HI1OvX7/ifIBg0aE8/oZ5ZDfgkRUdRNVV1doiEJ2O9cW+nVqKnwF67Tsm3gElYKaOTK4Sn1N6xrsq6h3FNGfE8Aae6yNviGthXBeOIcHiv+c02RzYX3c0lF1VXcRoysyFEuWQHFwbHUCaPPBp9YfjTx6iSm3+KB8KkLxfB83u3prTQfhC02W2MznID2tVNfGvYEPjSNni+Ogr7Ej3hKC190BNimDa5CR5d1fJYuzaTHBNNX85
 JN7SKllF
 LSQyF3evLv8296tIHLVhSbeHnHtFmG+2rYhqpo6LgaNuTQlSljL5z6ciiJ3j3ONCpGQ6Bmrlsn+cctGMKg9Q3QYJ+HpfHJ5uXeCCyGnWnOcC9v5EY+6sOdwKiP426rG5T4VnjE+zItBuAWqca3wQjPUS9jp259OBW9l+UW7r1EVjtHbOWjAJCPrko4tDAitoHxa65jZoqSyLIjmXpKNjzoT31GJov8bvvuE8UzYbv92Cxaupg9lOBIu5cn4AeffTV+/FMwqwArHVoOX3DKOO1tydYegexrPlGNY9D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Oct 31, 2025 at 08:59:51AM -0400, Phil Auld a écrit :
> > +int housekeeping_update(struct cpumask *mask, enum hk_type type)
> > +{
> > +	struct cpumask *trial, *old = NULL;
> > +
> > +	if (type != HK_TYPE_DOMAIN)
> > +		return -ENOTSUPP;
> > +
> > +	trial = kmalloc(sizeof(*trial), GFP_KERNEL);
> > +	if (!trial)
> > +		return -ENOMEM;
> > +
> > +	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), mask);
> > +	if (!cpumask_intersects(trial, cpu_online_mask)) {
> > +		kfree(trial);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!housekeeping.flags)
> > +		static_branch_enable(&housekeeping_overridden);
> > +
> > +	if (!(housekeeping.flags & BIT(type)))
> > +		old = housekeeping_cpumask_dereference(type);
> > +	else
> > +		WRITE_ONCE(housekeeping.flags, housekeeping.flags | BIT(type));
> 
> Isn't this backwards?   If the bit is not set you save old to free it
> and if the bit is set you set it again.

That's completely backward!

Thanks for pointing out!

-- 
Frederic Weisbecker
SUSE Labs

