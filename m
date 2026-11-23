Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC2B606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jub8/30H
Received: by kanga.kvack.org (Postfix)
	id A0C9B6B05B1; Mon, 23 Nov 2026 09:48:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3C76B05B2; Mon, 23 Nov 2026 09:48:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3216B05B3; Mon, 23 Nov 2026 09:48:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69B5D6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:48:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11B661A08EC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:48:32 +0000 (UTC)
X-FDA: 85466664864.23.9906914
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65E10160005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:48:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jub8/30H";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795445310;
	b=3Jjr5u2f83dIlsr4ZdDT8LP0hMkkmB/utffKbI0wgbJHZo3jU6t882cpexpWj6goZMyRo1
	AspvDbPKVue0NLqwhCI2pRy82GcBAGzlfKsimT5j2Vzm/kpKQlTiV8B9cQNfEUhUEh/Z9v
	LHVCZiOkglNBzm1pUv8oPn7z/Cm+plA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795445310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COU3p8mhLvRYDZ7TXv24gbV9Mm0T8HfG6LrqY+C2miU=;
	b=AAXDMFcke/EFzbGhF+DDBiTV6txujMC8ArtTPfK6ZXkttRhVrqEF4DQz+UOBAnPg2dDX3o
	B3qVZAhGPNDNn9iCqwGUHb/QzQDp/V8MbUtqU49ujvBRHk2fWay1dTYQycrKjUJWbwvlc0
	iU3/OxF/dEoCoNYnO5ueHAuebezo2+k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jub8/30H";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2DE06223E;
	Mon, 23 Nov 2026 14:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940581F000D3;
	Mon, 23 Nov 2026 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445309;
	bh=COU3p8mhLvRYDZ7TXv24gbV9Mm0T8HfG6LrqY+C2miU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jub8/30H77a+LnJJFaB1btgtBWhm94GK8KHAGpB6a/HGXmRdAq7SAM6x/AM623wMl
	 Szhxiz/FEmlHWT5Q1O4lyUHYSaVNnO5amh/WWhXeKtL3aP7RBN2kH9vVCIg9Yps6u0
	 qLJ0TMbfvC1EP4nMOAX04Rt6rjlT9MtKx0rSGR0jisdy+v+qIpzpK1NE9Cbo+d3wIn
	 h8/3Of/u2wqIBbq0sDikY8sbsamD7Njthic/O+IVOSB3aot1VsERiXetp+oM0GqjuW
	 bjMf3H7Yw4vJO9WbN1yQBcwPHv852222CzAAWfE9cIg0q2om49UTOx64T03/tk6pCk
	 zhkUaySt0kJ5g==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: kernel-team@meta.com,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Conor Dooley <conor@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 00/10] replace CONFIG_SLUB_TINY with a slab_tiny boot parameter
Date: Mon, 23 Nov 2026 14:48:20 +0000
Message-ID: <179544526762.3606123.14263351659988256833.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 65E10160005
X-Stat-Signature: wwj3wb4dfeswrwrja6q57hxjhaos374u
X-HE-Tag: 1795445310-959965
X-HE-Meta: U2FsdGVkX18UTuCb1CYQHgTFdEdyF2mcrkwIHGcpq2jtZFUXbhO+on3myowQqGbGXEl5oSJY5iL2E/dmTw3hpS30nBHJ6WMfVr0LyIRKZ9IEq3A9jucLhQ4txIziuf4qN9EU/AmrrrSLdlHg3FeYa5cOSXu04hFHgfrtTPBL4C4WpgwiJw4oLJ5NZqKd8FkEzEuSMTQVLguMMBvVE3n1TOIeJjQyY9w371aWhWG9Nw8eeRxN3C+ZNHEZGHiQu5mIQKG4hva2Q9WbUpTnJQbOs6PtXZnp1+3jRdOQVmLbizg9Wk2J7ioP8O8TDIUNhziQDqEI6bsPv6JUEAHe9IrKU1PiXSSbmK79UqoO5n8J+WoIUIFNWnu4+14JRreQp2E3/v53VeAU24gqFmn5WZ4PMn9fIz+oVLcVba1+QdEKc3ZbzWfONIqYHJeBAiN6WUnCZzW343nLnJlE92056FfwxyROaELvbzUt9tIf1imft0kMFMiiQUSTiL61aNAusd2ytlUPBHx3FXQDtYtVPNPULBRMR65qbzGIUHFpjjaiEcteVneFwoyv/AbLWjTDWm08qK+Z+3l1OrD6Y1M64mebXJBCe1R8QzEQYL/dnG6k5wowG4UlZC5F0zC4gBbDHUhr6aUhnWzmNQBe5SfANpC+5BBh2iaZfyixLkIk22LXdOhUI4/tgvzbN86f4ZqiUF+XXFJKCE2q+UcNnMl4tP4kQmq/BO/m58xy6w5W8ktdYBtfV1qzyN5HQrZXP4J+uVUU7xYHP1rrw9fCxofRqcZYXcEmHGyvz4TZmMvz3j9PtWR6juPhjlxNUtQgoiA3h7fgOMJN+n1+2iqCn4Qx1vg4C80M9U6Yzsc3jpkaAztk0PPUgjzYhD/ZPH6j6dtcFxCAkejmVFtm8XNQgIHnZRhDm1Q0G8fYX3SeHMfrCd/KGRxbhmcp9L+7ml84D77bhllzMwUI4r6Rt+9g/i/cA8F
 kCF4LS5I
 LJIpGR/aauNHImeuxLJ2Mpmz+exCuaR4KW29uS+ZMAFLosXhxK8f9T4QKeIm2dNZFvRcbj2PPcz8HNOL/VDG2yMLBkuWA16hZagbKhcoHpYQjtyNT/67n5e15nCaS70DBTzXa5ZhICZ4hnY4TPGe6VLV1WH1QbCUa4X5gE/gUOKL/9A7uQ9Kt9VE+Ouopm0YQAQweb0aoWU7HBG/nbocFBoOV3/LztDuwd4yYlD98xnH64lwB5dGUOWUU5iOJyYPtGjgAxIB0OZ9aXj85wGhf4U10o0d7qbReYM+hcrg+R7dBOmBYXRDjERIhSS287Q6jofFLtU2s/xO4V60SFxAF/Jogyoqo761kWVX3ugMcZXlLG71VVY40FcIe7F6WVDn3OdpwPCL4vWB5aP8bzHv8fY4TDfHRZAe9x8iJ3iLNHimrIng8mP9Axz17fykkUGwEgUFqI5Qf1nA0gDhL3/vnZtSZFTXOwO2RpRiRo7xR3CM9VgJ6dfgyqeaiofbhfkDd6+jqDsWS2lpXuiZLnKzFcUafq1na1LGmopnR0698I9JrI9/BdN9fzRtQIsa9vxEHjmA6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 07:47:08 +0100, Vlastimil Babka (SUSE) wrote:
> CONFIG_SLUB_TINY was introduced to help tiny systems migrate away from
> the SLOB implementation so it could be removed. Its main purpose has
> been to disable all forms of percpu object caching (cpu slabs back then,
> now sheaves), and being a compile-time config option, some extra minor
> saving were achieved by code elimination or more agressive merging of
> caches with reclaimable and non-reclaimable objects (keeping those
> separate helps reduce high-order page fragmentation but not memory
> footprint).
> 
> [...]

Applied to mm/slab.git for-next, thanks!

[01/10] slab, kunit: pin test slabs by an extra allocation
        commit: 59cb3f752d7df4badc0ff6caf1b13ba293049b79
[02/10] kasan, kunit: pin test slabs by an extra allocation
        commit: b5f4208f057248d96adf876e50e03a7c92cb82ea
[03/10] mm, slab: refactor slab_min/max_order handling
        commit: bea9fb71610535595f7d39715ca47248c785110a
[04/10] mm, slab: introduce slab_debug=N
        commit: c6fe42e8966e517773fcb41efd02c7cb2eab9697
[05/10] mm, slab: rework KMALLOC_RECLAIM handling of SLUB_TINY
        commit: 5e3df3c9656df19053909c4aa70792007c5ddc59
[06/10] mm, slab: make SLUB_TINY handling dynamic for sizing decisions
        commit: 0582f36165726165012f66be8924e2123d679795
[07/10] mm, slab: convert CONFIG_SLUB_TINY checks to kmem_cache_debug()
        commit: 7d6e6d4e50b91ede6662ea177e25b38b3bfbffb9
[08/10] mm, slab: remove remaining compile-time checks for CONFIG_SLUB_TINY
        commit: 0ecb9fa1456b356e604848542787aeb6b87b6505
[09/10] mm, slab: add slab_tiny boot param
        commit: 9d83e029638706e283df6079ff4db017e8881769
[10/10] mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects
        commit: 3464ad6cacfa65099378798cc0d95c9e5151e86d

-- 
Cheers,
Harry / Hyeonggon


