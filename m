Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4588C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A4A6B008A; Thu, 30 Jul 2026 16:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0F46B008C; Thu, 30 Jul 2026 16:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F76D6B0092; Thu, 30 Jul 2026 16:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFD56B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:09:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE1EC40267
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:09:27 +0000 (UTC)
X-FDA: 85046532774.27.3F23136
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D43D7A000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:09:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TgUNY2iQ;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785442166;
	b=eLaBeELOBNf78t5FU7XNzPghekqK2MBgiFn4FhN8relyiVwO1fmqTbt7q/8+styu8u1Y3/
	NhWoNWh0eY4NxN3ilJAjf3HVtjOOWvznmViJdBH0Y8uEegSINgbxG3fmDYXWLIFZPsKTlo
	x2hATNGdtZZh9r5fzeLZxgtYvib+Kmw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TgUNY2iQ;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785442166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppIl39HqOgOmvBcM1jT+W3KYEtutlYLvJ6BsOLLLIbI=;
	b=tHdMDI7AldPpX0gvJV/vsvQ+BzVOWp1n9wvtfaJYPs5AY+SisLsdaXDHN52QtQALYewGF7
	9xeYARqNPSsUNZ4XMY1+/RdiNwNPMhKuwnWv/sPopDW3Nucpor3EzFjoEvwJq38oi8Gwo5
	55RGoTDJRdXbULqn0aCkRhIAPvUfEUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DF2E438CC;
	Thu, 30 Jul 2026 20:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F8B1F000E9;
	Thu, 30 Jul 2026 20:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785442163;
	bh=ppIl39HqOgOmvBcM1jT+W3KYEtutlYLvJ6BsOLLLIbI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TgUNY2iQp/Uwz3gfVwJIdYH3sVFJKwqq/OjJAwmaL/PbUhPDocI606UhUV5mIDBYW
	 d3g1uXit5HFJHdGKvlWXrzdx5CQo6ZYfPZC0vMt6j3c8FSUfZVA/Err709gj9716bY
	 LkA2UzVzzpXJ2cNrGML+fNmmVuZ4i1nk9rMWArYc=
Date: Thu, 30 Jul 2026 13:09:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Lytkin <iprintercanon@gmail.com>
Cc: linux-mm@kvack.org, urezki@gmail.com, willy@infradead.org,
 shivamkalra98@zohomail.in, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm/vmalloc: stop truncating byte counts derived
 from nr_pages
Message-Id: <20260730130923.9e71be5f477ee3db333cf0f8@linux-foundation.org>
In-Reply-To: <20260730090628.65814-1-iprintercanon@gmail.com>
References: <20260729175708.7074-1-iprintercanon@gmail.com>
	<20260730090628.65814-1-iprintercanon@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D43D7A000B
X-Stat-Signature: bzxr6wwh9edz9icfbazybtmezke5rq86
X-Rspam-User: 
X-HE-Tag: 1785442165-102985
X-HE-Meta: U2FsdGVkX1/yEUzZpdketQDl0epGJVIdqzCGxO3cGXFg0kam5bDBABT3QmbGX+JUpmdPeGEfUkQDGk9UvlH0CQejMZt8IYPia0N7yXAqHi/Cg3ZBrCwyKb+NS3W3g+busnvTtC3xj3XSnIDLwAW5qt6Y2jiGLU9mQ3yLnHS8+gAhEwxpCiF1lnlJ9cMtT62XKGUAdp4Hvy+PPO2fLstPbvJ818eS9soakZnOEC2AJoIlHsn2gum/8Qg5LroQ6J2P1ZN5EavJdggMlxGMajCnx82Y6EVEnqlHUHNpmXsogLBYA1niJOv4fbnnzk6FxSGRdCAXhrUFgEEG49BXHMfQDd2fftWXqcNVD6BuwQMR1j0PjTZdnwFnyi+GoU4by0cxCSAyPgvKpYCSKEZT/2AZBZI0URscK2MXBhqKOMa7rtuZERDcVIy6MwKdMka9s0k7mk4CygaM2I6T8ejGMvg3Eq8SiBB0oYbE6nEiu62Pnqfcwm0OXBtkodYq2csxQwRhZE0KzoL2q0FWTtvc/+tKSmOvmm5DPmX+orv+B7GC6wVu+kwnQfdnPh2YwYBcG5M/EGMdX/d5t8LS2WMBRy05ubf45YG7Lu9UrvBwV2uvXxUJdAPXHvqxExzKh+xeZHevI9qlteWTKZ4nT0AiW08CN0dEPPBwQ89Ac8+PtvVuAHFJns4YAOKwQt84oL1rvNfyYo0L1+3QTfdEMqC4+aQ7EpHIrGEYLkP51bbYJ5LkBQtH3/ISKrE0XqhIDASv9x7IX0gwFPDy8g8SQ0+jHRo4CX1ye6f01bLebq5J6JZyXELUmC/wUhdKR9n26xVcfRd1s2q2VMwhvadU2kVjvmatSF8yURc47LX2UefRywDllzx4xynVGnfan+ZONV4/QzcIBnsHQZMcDNcGcHqpdRKY2bCSJeXtkZc7NFGt+brycvHTxUmKmqWbWcT0BZxC/MXZ9vAjDv3DGeIczxMXC7a
 JH05O3HA
 TfZ0pPHeEixXmB98DH/DYxKwEseJNiTHQuXUiP6ZWCADIpUsS7PokW8cKSPDXkO+sPAtf7OXy9DLZYt3bLd6atRa4srXgbK1qL6ksZwI/pRZDGH+899GFTFoaqUczcPrYRXGKtW8xlGaEz0WfGboRM5WLmsVA5CRa+08CCMIyPVCtC0gWSWuJzHUxA68cmngLxPofU7oVgGlhQhWMOJjezzJmGf0+0ckCU9GiJp6AvQHkMluRqrDtewfhFdlPHXYb5D+GwH6OHr3Z1EC04XtJF2zkcD8V65uSiJM2XSTLxyhFbNR1NNkQeUotKpf933jgrAdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 12:06:25 +0300 Artem Lytkin <iprintercanon@gmail.com> wrote:

> Andrew asked for a v2 of the nr_pages widening, rebased on mm-new, with
> the changelog clarified on what has actually been observed.
> 
> The widening reverts the two casts added by the patches I sent on 25
> July, so it needs those in the tree first, and they are not in mm-new,
> mm-unstable or mm-hotfixes-unstable today. They are here as 1/3 and 2/3 so
> that the series applies and Sashiko can chew on it. 2/3 is byte for byte
> what I sent; 1/3 has one corrected sentence in its changelog and the same
> one-line diff.

Sashiko couldn't apply it for some reason.

This all seems far too complex for such an obscure issue.

How about we queue just a single switch-to-ulong patch, add that to 7.3
and give it a Fixes:0bca23804632/cc:stable so 7.2.x gets fixed later?

