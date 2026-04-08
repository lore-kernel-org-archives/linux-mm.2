Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896CF1073C98
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE8A6B0088; Wed,  8 Apr 2026 07:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F176B0089; Wed,  8 Apr 2026 07:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94FD6B008A; Wed,  8 Apr 2026 07:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9945B6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:16:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41AA7E2956
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:16:41 +0000 (UTC)
X-FDA: 84635135802.14.7C58485
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3164C000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:16:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=P1bjmjpC;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775646998; a=rsa-sha256;
	cv=none;
	b=uOFfN+LxTOcMGxovN2LHTGFZnaQj9o9d+AaNHNeHntwBypkH159jR3kVRz+bfINZYFBzRv
	qfIcvMgRPxUsfaq2qyGd34b+Ab4mJbykHlO/KPSSpJ3Pjj18xdE0X0pT6l9bx3vOFjHlds
	apYIzZRE81Xl27NZPmipfKmfEB3XE7Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775646998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFbMXrldq36UH6h3zAVxylgeW7SVg8YvoOzRknXJSSw=;
	b=6R7lxP93sYHFNUxsgJ8aowWDAHVvFo1hBgcf3DXVarri6W17ZCkiRc5ibZ9eGelJjqkH/h
	7C4psfBz0BKm5KnrZYvLE3En8divORCTuC3k0ntwN+0sMbNZAmDIkQ5aJa+5fDKUHAnpfv
	RS/wIP28ei6BvU5Tvl6Hx4qcw5w4nPQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=P1bjmjpC;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uFbMXrldq36UH6h3zAVxylgeW7SVg8YvoOzRknXJSSw=; b=P1bjmjpCaOgzgJVjOk1hfmq5Di
	BO4I+Jbwk57MjUT5mmSNxC75RvYtheinmp6CY7ZoLxCdUJRZWR1o4hVrock8zxi885YpT9cnDw5vQ
	5otBNk2rq4lNSj+6BuuTKXo0nOq9tGQvcaPKbDpO5OEq+P6rDaFhwffVLS/SvpPFk6TVf13ET+BD7
	iO1Y1faEpUcmgHX7OjkWfYRdmZDLckZKo7jFiBImSFv8EiucEh8I59bKL9uLoqEB8TsPQOePn6/yF
	v2r96F88Z8Cj9a63FZS+4eKXugUWu+d5TLupSOuwzKllNVEq+VPqKIcr99NA+hhMHctve/BFXaEDo
	9su6MsIw==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAQte-00000009v7A-3fvD;
	Wed, 08 Apr 2026 11:16:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A46733021A4; Wed, 08 Apr 2026 13:16:32 +0200 (CEST)
Date: Wed, 8 Apr 2026 13:16:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
Message-ID: <20260408111632.GI3558198@noisy.programming.kicks-ass.net>
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
 <1267a6c0-f8e7-4708-96da-4d131b5c6069@arm.com>
 <c7688962-d10c-49e1-a434-ab7ae2c64cdb@kernel.org>
 <20260407071820.GA3738010@noisy.programming.kicks-ass.net>
 <bcf784d9-5350-4b43-a827-a1cead862cad@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf784d9-5350-4b43-a827-a1cead862cad@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3164C000C
X-Stat-Signature: p9cuo1sfkcurxnnmnxpcck7kcwidg3d4
X-HE-Tag: 1775646997-704788
X-HE-Meta: U2FsdGVkX1/afTxVkRRI354evxeo7V675kbzzZ0+UrKmkph4ABYk+XxLe9o85cY9dgzzAZpWi6xVkK19BwkvPfPBRwczlqEp+/FR8dUOqxO8M8Zw5LT9wB4PT35Ln5KKeSfl2v6uI4vGE0M2fFZrfacdXI9w/fRr2fwnnyJS632PgaF8Ov2gUY84jEXz3HFtZOutqlvgfu+hqj+rogXiiadLd+tRJs3Iyx8hZaDArsWYWlW1C+v08hdP7T4DEj8K7S+Pynk6J3LWPTgGhw93lww+Cz3QcNXJWKvCstk4KLSFfTjmVFvc2wk7JZQYYi/C4ZMH0K3QPG7OmQGRz0hFAgFvjPBTtc3MIqrYPgUMoD2ytdgzGxGJXZN6+anRedzTC0vSA2bW77Xh1bW7oC1uGJusuSJLr3EgTBgVmkjfXWu4POFEBgoBkN0NJWU+YJ0m3X0LwzXaVZ1f4eMU9yMqsvxksENBU6NT+m2lXXrOa1SmPXaWmelLZ2htR0DSzwOuzP8nwiszXjxtm6zbLA3qnsGKT2c471A+gPJ/HEIXQUCK3LiWTKmp+Uh0+/YfN/qDGm8QfkRMqTXeJLy9/eD0m2QqLNsRT/XTljxcPm60brcXyfRzeh+khWm+laLJscWm7/ZcJU1OslWW0wRYHLHZzmEfSbsoOae7KV/pPyKUxk072h1Uvs+9tOmzQxUy07GwjznrvaTLDAqdN68w4BYYYzfEge/c4qyt89rTmHt9xQDIi6vgGsqGQHf94uyGlZ/hsSqwbr4mPAm6lPgbKfbty5i6k8NSdlVM76T7QA4OBA1xeu+WjLbGyxOXDUW8BO5i+NfowRyZEbOzEaRt0JXTfV3rMxMfliVPosTLoz+zbqoBszvWkHoDSEUwCs68XQGBw7bxXB8B8dMCF+dXUh0OPxSD9VAX9Jh5zpw8nelKD5K5V1Ks0YSklA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 04:28:48PM +0530, Anshuman Khandual wrote:

> It would be great if you could pick this up. Thanks !

OK done. Should be in tomorrow's -next I suppose.

