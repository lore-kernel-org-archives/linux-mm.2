Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96797CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 13:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8146B0092; Sat, 23 May 2026 09:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658746B0095; Sat, 23 May 2026 09:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56DE86B0096; Sat, 23 May 2026 09:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 447096B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 09:50:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEEF5140B0F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:50:49 +0000 (UTC)
X-FDA: 84798820218.11.EE49875
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3AD8DC0004
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:50:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=cNcsZ54F;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779544248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AC/2/8v0gXhGn6yBxeQK/GPYzfG5O7Mk+gnTKcGs3Js=;
	b=GzJXrnfIbVorDS1RUkoyr5P2ArCVYIZ1HjF/IiDnvimR2OXo52KAP46UfJJN39qq1O+Jok
	RVZAxsM6qcFW8Zx8//CrUcI33cUdwrg2zI+gA/K7wxtSMI5kYJWqXRZKI+Q+TB1Jh1dNRE
	lo5aj3kzg9M9iiGX7HCxMs8xLWguCxw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=cNcsZ54F;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779544248; a=rsa-sha256;
	cv=none;
	b=hdO+1SkTKK3yS4hAVHw/IZs8a/SJubZ2llfIbQao2GISDVgx1R60Lh9v6UYc2LPpygp2JA
	ehn91KVn5evCBVnrXRSynDgHPGYPmNNL6FgAnLNvE32eUj3xcJ8O9xrc6VenS6xFRPdPGu
	NgPq7S9yJ83AMUiPhbp0TPLbUE79n9k=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 8FE79D0A8D;
	Sat, 23 May 2026 13:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779544246;
	bh=AC/2/8v0gXhGn6yBxeQK/GPYzfG5O7Mk+gnTKcGs3Js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cNcsZ54F2iJQFEFkHSCOO+HYLmbg8zCOX/YYa8WnJn+NxHFvmxwfVNbKnJXwkEnws
	 4V1ny2G1nO5rlNwTtMVCwPt0t9xDiQs6S/OaI8kZKK+pwCMmxeO9d1S1CADcKiH+fF
	 Kt2NWMbrQYRlG95yRMdF6yCDUdjOKOws/KlJe6g0=
Date: Sat, 23 May 2026 13:50:45 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-ID: <ahGwteXHpBsPbpm1@shell.ilvokhin.com>
References: <20260520122228.201550-1-d@ilvokhin.com>
 <20260521165910.e7dea6a4e591d66293d2bd47@linux-foundation.org>
 <ahBUoB15hHbIyZMr@shell.ilvokhin.com>
 <20260522195426.6e764847f4c4dcbaad388291@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522195426.6e764847f4c4dcbaad388291@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AD8DC0004
X-Rspam-User: 
X-Stat-Signature: ux7y5tfqkcebc6c6h5ixuyca3zn7whtb
X-HE-Tag: 1779544248-44474
X-HE-Meta: U2FsdGVkX192oJwcT47m91tM3mo2Kp2nQndfh0iPDIgGsTmHU5MoTbZcd1KAVyKzLz3QA8xyoGjsheN1EfBfvxIrZpuOURyMP1NcYHXVbRm293R6airqMoLictDJ3Vl9UF5pxBWb+HM2LZ3u8pKRllrLIOGbTTeyb0kYo5T9pwHkQ007IyRxtVtNlPghbR5cR+J6iHEDEr1MFyZ5yLcDGt9u7+UPXavfpRtZjdwjASh9PerPU7I/xGyV/rA82liIhG2W/eJREQ3YzV+ClhbnEbSwUXVrjk1yqiXtEfGV5rNYAhYmQrLM65JUnqQu0iJa6IF2hbQhGBeSvhDfnYlK2C/H10pMoesdyl4qWGahXi+oYiZvd2VkO83/YVV34dHyM5JGxkO9z/0nOfXajEeSFf5eQloEuEswYcM9J6mU04dY+JLuT7SfcInM1GjuAU/nTQgU3GE+KlnoCkC9EUMixNqnhFm0TrfY8N5CuUJShBcgkxlj+4jU5Umt+dDBlyUfjqD1OdAeXuksUeoBxwg9L6tM5M2BbLlGUlUNsGCVe36tArOZ04sv8nfq/G/0TKcqGSOCgiZ3SI953Sw3SqOuaSSNuZR8reuE0CsJBbgM2byEUSU2Sehng59N7kCjfyECSs8p7gr9arVw+tdSNRQWsfltZ/o5QO09rjMV4Bx22wau8sXoQaA8+TdA8KbTLTzFjv/yZNOBzFgEl939Ci59gabvznrTc/EGQ4egl/KD/2sSaTXELMqkLOZS1krTM9r1JvQZzRzB+PvhXQpsVSFVsX7JFUU88uzIMwFaSSAwxYmVpsMb4S0HRr56VeZsXq+fPeJHZUDB/4M9W0DzvRAzr7D6ksOfsItfo5K7ALZv5DiUSPkzoUbLjGOELxpc9HDQAhDqYgqmb4l1dsmrHzU0qwyRH8WSFqL0HSh2BVX54H2ll9GjzOUZfalYkp5A7zSJZUhCy9wAvQMRFCP4b6K
 E6BSbLu0
 gQZLm0v5x0NM+Dlu2Q5tXu6mHgajGfT++qJG3HIEiUv2uirYV2TMcvC23xqApDqZU416UwOm+Dq2CMnSy1YvL+jqYlGWFaDNECBhZsSRRVDf2bD7/KeLG1zxe4BmvO1zHx+v5hrcA6eK7noK2q7YOXUcAGDLt95UhtdLpezKuHokhoT1aoXYR16IryOlbebvPq9DBr4m6kWkXYMg4/KJnwinsS23f3xsajY1M2boDfTYSOthHj+VhdFE77UbjDyluljctvV1ulEqxBLymmGVW0szfgEV3ABbx9nQc2nFy+pKr4mxtijhMrKBJaadEhsHl3OB0NSmcFxRTaElDB/xhK8N92Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 07:54:26PM -0700, Andrew Morton wrote:
> On Fri, 22 May 2026 13:05:36 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > > How serious is this to our users when running real-world workloads?
> > 
> > We observed it on a few of the Meta workloads that adopted
> > defrag_mode=1.
> > 
> > For the service under load there were 85509 SLUB allocation failures
> > messages in dmesg within 2 hours. All of them are GFP_ATOMIC allocations
> > for skbuff_head_cache, despite free pages being available in other
> > migratetype freelists (~13 GB free).
> 
> For a single machine, I assume.

Yes, all of that data is from a single machine.

> 
> > Since it is networking path from the practical point of view, this means
> > dropped packets, failed RPC requests, tail latency spikes and overall
> > service degradation.
> 
> OK, thanks.   I assume 12 failures per second isn't a disaster, and that
> there's no need to fast-track this into 7.1?

Yes, I agree. No need to fast-track this.

