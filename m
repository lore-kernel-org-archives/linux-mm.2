Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E1E606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CpFvDYs9
Received: by kanga.kvack.org (Postfix)
	id 60C626B05C3; Mon,  2 Nov 2026 05:19:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5970B6B05C4; Mon,  2 Nov 2026 05:19:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EEC6B05C5; Mon,  2 Nov 2026 05:19:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 211106B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:19:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0E28C0C80
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:10 +0000 (UTC)
X-FDA: 85389781260.05.1803259
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EB3164000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CpFvDYs9;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614749;
	b=LQAmfhtFHDdE9G6eHwoWpTG552k5i45nm2CCBBaCoflMXyGSdhX096So1qBWEmcdSG+gLs
	QOy7topPucFOjaP7LmpbmnZjBfo8HFHQEWdGzd6e41XkRw2xFwO/4Fwz9o0NjoQFFc/8uY
	Izmc3f434Vv7YNqCGquYTpvwLoonHPg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CpFvDYs9;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SRV5FSJTfbiUrmKVm9iO7XnZ9kNn48288RtL7ogiPk=;
	b=i/uRexshiKF2w2oFZ3ll0XWSfzi0UD1tBp1BT0CEv8tSMFhnUBc+sGF8nNtTT5T8oA8iAg
	jM5RqXidySH4icBm/FmsCxMNNxLSaj9QoEUzwtpvs0iz+zrE8g9wE4Dg0n+VvNc0LXyLwr
	xSqYx3ZzANX8IljEEp0wCtd+RNPdfTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A6DC43EFD;
	Mon,  2 Nov 2026 10:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC86A1F00A21;
	Mon,  2 Nov 2026 10:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614748;
	bh=2SRV5FSJTfbiUrmKVm9iO7XnZ9kNn48288RtL7ogiPk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=CpFvDYs9htA9hVrKALdU3qYT2NeHXflE9aDmKWM86QDPZyWSbNzdHEgSXI5hZ53dD
	 XvIXTvOmd69onHM/24o5gsiGglENzLLa4OhjD7ppjMtdwgpP2niRfzfVwOGUyDgWpv
	 6q1SbpybSJoTj18pX+j1YHtLyQF+cgAqXniILWTaJVW/4FHo+O+GTvcqup6VQ/bktl
	 +qu0DDo8O8hf30Y/owgMaTwuzch6ZXw5BiDw3ptHKb2sNYb2bI1vTPawdVdjmA2Slz
	 8IvxOG06mSHVDZVTEn1ZBbaOuL10otd85FBE0uL/0qyzN1XVyqzg0/7/Y2y01A9zs8
	 gIqdRPX7emWHQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 11/12] mm: hugetlb_vmemmap: unify vmemmap range
 restoration
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-12-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-12-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471105.1337633.15759596677330627009.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 7suha7dcqzb98ptrxkmghtxnaag6tfw4
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB3164000B
X-Rspam-User: 
X-HE-Tag: 1793614748-580150
X-HE-Meta: U2FsdGVkX19r1l9LVO3ksNYmf9bi2LgYAGnck+h43ExLz0F81a9eN5KGqdVQw+jsrWgvVIz/5z+bcKMjiF4pBG+/6VhoBTOyygw9GSxJR9qVz5DzsSGRP/yDy1HSDD05mRp/hJzo7JE435jxMvJ2vmJRX0/019U602EJtcD5AxcKtPy03yfOhWY+WRbPdYYXtFxzThCME6Lab7m55L2SnptLXzdsB2NsBe0A+a82yJ/xRYbld4IZjcoRYP5joqpAldt2f7I4Umtl8zQONWVSJ4e962K25ANm2IVv6XIp9SVQelF3Kj6yfNsv/NHwGMhNN5kFbtZViTJ5W6J9Dj6l3qELs8Bd5QToofywMeexfx3PchQ3WhyCcmvdKVwbI1T6/BtCOHdYuyLvEiOe9s6T7BAp8VWl82tuPrLVD3j3gTl5ckywz13NZQqGWjDoVN6juXEVAgRYZhFaZ90Jcyy1Og6kakTfUssWSzqAjx0+JSCOkaWXNPE8k3z74h6yEox3TvRVTVv04IZH80ZyFFwZzAeDM3mltVUJl4rw/lV7YpQxNuhGd7x8dxk3TNkj+cZJ0HoYcEDWpKLvS1DCzSK9LRgeg1TI5Tei6T+P4F/Xydbdpm/aQCpkdgiPcewGh1ChmQS7jYJpaa48jr4rLESGO6kBHUcOjWfSXjlsKOZpRhY9G9MzhmGmXvGfM9F3CdUjUpiJTYpgzODnxCiNE5xuOSdNoofG7JlivtGCMzVcBRA7nIIP/9GZdq4ICkFoR8qCT6txc4BYoGkd4fUBuzHu2WFok8G1/uNldl53+PszPi8p+WTUzxcOrOY6f1WBw9xWxk/k9ag0igjtNxNRGlK2YwmCLt/WmZGxjzmDa4d4z/nRpL8sf/X/jayoZrJZq35VqKBYQcADUwvKJAKfj+BGUGJ/oxA7Ujqm3Yjswnh3RqI1YRKNNKZYh0XT+XjLvu6nVMxMsucsypMn1+syQGm
 GUzFYtc0
 OMCFMavl38/D+m3FQx6+DqP/V2ulwgtabzXOKtkYuaYKAOfAmFY51AoEaQb924CE1QafPmo6Gaf+yF3s5BzR7qHpipBwrBrqLVOH1w7Oe9aO9zz6ZjGiYziUdg23/iA4lZm24n2af4tuCsZuHtan6WDLPe3SHwGEd+GkNGK7/4ZrzzRMKdDyc/ybxmBuNc45lSjvTKCi1fxr90SOurzPq4OV+SpdqQ7pfsQ1rrOIAN4R/P1yGFMOhcckoPuVZFm3O6PLk2uv5D6vyaywWMHb0HY0gaV64kkZ9ClLExZbGBcNlsQ/UinypaldjLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 11:25:24 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Restoring an optimized folio and rolling back a partial optimization
> both restore a vmemmap range, but the operation is currently implemented
> separately in each path.
> 
> Use a single range-restoration path for both cases, making rollback an
> explicit bounded form of normal restoration.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


