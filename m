Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BA8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A326B0005; Mon, 13 Jul 2026 08:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D426B0088; Mon, 13 Jul 2026 08:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52D86B008A; Mon, 13 Jul 2026 08:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8C956B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:31:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F1091C58BA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:31:13 +0000 (UTC)
X-FDA: 84983688426.06.37BC258
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2B5FBC000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:31:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JfRMoYe/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783945871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JI+/o9g62QcrTsdBJA8Y9yefEkfCO4FlJVcAJIAYH+A=;
	b=XMpCENzhQhWDuOdLE6B7/Yyr17vOSX2/KOEj2bXbOKzhqHBWzFwZAjubAd1JlSZu40JyiE
	XoLFU6wS3st7fnTzz8ozCEnQ8ia4c8VM+MOD/XAhG/W2sQcCa45OR0h9AtI51AlcJAmkwT
	u+WjXiARf5w4eoDmCV327CBtHzyfcq4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JfRMoYe/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783945871;
	b=I0SGteb7kGWEQveMXIEzfQBJYW26W4FfZ7HhDUd45E5vJjIwCLi4epKb8URZ/7MwZMDLD+
	0HEzYcqH9qSJm28K9EdVLW3mCn5Q+hfMYKzTXGi+WvZbZfS8Re0yggeVSJZt7wg2EjCH/3
	uptpZ4aDWe401wmSlMm50C7VXe8QgmY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783945869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JI+/o9g62QcrTsdBJA8Y9yefEkfCO4FlJVcAJIAYH+A=;
	b=JfRMoYe/osc67xC5UABSw/Jid07sqLX65BD/x+9RL9hscga8kjPX1PdLGZ8PW0DzBQwJRO
	pH+MmCQrpYIYZwFKQCfjkAF0s5YR+BnX3cAxQIfMUrcSSoCrV9DdPJpof+re3Sdwlwsxbz
	NHLsfxHkgMFEqPjPJnO7Ywt7bSI0IBc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: memcg-v1: account vmpressure event allocations
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
Date: Mon, 13 Jul 2026 20:30:31 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Stanislav Fort <stanislav.fort@aisle.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <523274F8-9DE3-406A-80BF-00AF0610D033@linux.dev>
References: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2B5FBC000F
X-Stat-Signature: kn9odywnbrokizfotnw7am1cg3a5kxnt
X-Rspam-User: 
X-HE-Tag: 1783945870-151263
X-HE-Meta: U2FsdGVkX1/gFnCmi7IMXYPdMgu9J/EU+8BFdY8hYBYL56yAntsEtVad4wLePLvOK8BZTuaiur9rxS6edMgtdUF+i4oqNDKLyO+yXrwxcMnYz60Ru+Ft+rHUWntuErEBp7bQmyBmChZ9uNuX6rNVn5qaKL2GcOfvo4JHathhoyH9xN7mLLv8TPZCASwFnjkzgzlMr5TCdV8FgqLcmodt8Up8f7wadPSgKWQSibyt6IBdGgkcn9vJNmTWKftV6amYGLeEni9ETHSrKFstbAkiwp4j1O+/x4deBwIvPonhhijx/a2VaNr+fgfebDxvyf3kZt25Qw/OsjXsOcnAWTe4J+fmKIjzQghTrRt0tyBecLsbVjStyHZhYb8vy0DnIhuf9uZjqyUf40Oh89tCahjm6/uhaTkwbcMx/VRyUOQP/ESvJYbVdZxs0e7WSQYZe97XypCXZFmdWF2XMrjwY6tYP89dBrd35IWdnOnAf4yOZ8TVkTtQLOlZI3a52LFemklV1rbANc7/q7P+8JS7FBwpMN97Jjqku6UZnQW4g+gM7MgSOmLjv6P+bTPOw/pSDXouo5Hps2XGQllNCjvp3GXdA7bysj2msyR4xAf19GbW3X/gIB2qUGFEC42CWleDPBUjue6f+HxehcbjoTAFqXmYT9TsDPdfxvI96VMDX+qdsEz1WNG+517X2gbfE6cOZBaV/GNEOfg8K/MH/Bqk4sVOD4Eynl+ddI4fCa2RqyHln5xTbVMuirVJ0r0H4XrvY4Jaycse1WtQc59RW0L9d0jAeK9+GvJCRZMvGU7VukjD3FNLnCHEIYt1xjY2NtKCpXKHOiQWPai852jaYiK34AZyE8+90K9hIfSeiuj/rcsbxatZvyPpIRhbLDuBVmj3kZ/OBcJS+HefwpHN02N9hU0USXEF6qA5uzUKei/6h7tCb7ecndsxAJ9oEtiV3JEAoaCAfYgHv7t2DH6uWq4KLlK
 XRNvs8TH
 07ldT14YO6j27I5+urqwnljcgTlwbMDrdbMdPq+jf3RxI41vuJRFTqGR/snieXX3IyrjOh8YIbM4Dp8B/paF9lsAcIYphJP9Ij44TCbKyjdZ2vyrWiu7GLvlJ00BNCN9dZzzToi5wij3XpaBikEL36VS3HLFdkVde4ieBaQuhijLhFwIGESocwvx0F7djjTJbhHFX2y1PRHQKYB7OW/JsQvXk42ifi8Sz9ef9OCGLtkiFAV70TK0Wm6Z7aD0txQbaXnuuZ7vu7Ei+LPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 13, 2026, at 16:55, Guopeng Zhang <guopeng.zhang@linux.dev> =
wrote:
>=20
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>=20
> Commit 72797d218b43 ("mm/memcg: v1: account event registrations and =
drop
> world-writable cgroup.event_control") accounted cgroup v1 event
> registration allocations with GFP_KERNEL_ACCOUNT, but missed struct
> vmpressure_event.
>=20
> Use GFP_KERNEL_ACCOUNT for this allocation as well.
>=20
> Fixes: 72797d218b43 ("mm/memcg: v1: account event registrations and =
drop world-writable cgroup.event_control")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



