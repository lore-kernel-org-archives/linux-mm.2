Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB3DCCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93456B00EB; Mon, 19 Oct 2026 10:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44226B00ED; Mon, 19 Oct 2026 10:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0ADA6B00EE; Mon, 19 Oct 2026 10:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6F26B00EB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:23:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E30101A0740
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:23:51 +0000 (UTC)
X-FDA: 85339594662.29.827B6C6
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 137DB1C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:23:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="RBFG6/84";
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792419830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynTwWaih3UWb7VmKOqAZKdwwEp9nTZ8YKOhE35tWuk0=;
	b=X4/53uMy7Hg5ULetJuPvCNukMdOjCDCKyAfE7dI6en9h39JprV/R4AA+6OuFS0+ipY+PhP
	yc3tgohVqSExDkNTmsKWmThDR/jmBIcvlv1SMkedZDziIITO/gX2xEnVXsCkWwBKOKMoUc
	fYHc5DrJk2JFO1ractzJ/I5bQQ4OgHs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="RBFG6/84";
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792419830;
	b=1zA59NYOQYiCZUUVmQMuoLZ29qMYPzVPKX++zl8SqRJr1ajoV2a/e4SUfQTbTKO2Tup0Zs
	LMOEKKd64bKXREoGU44jcuc7Ywdv9O8bzG5iL1TEord2mmTBD21DB1E9EoALSZHwVgJ5zT
	tMVlbEP8S4AnFV0+zPi6NxSnVXDhxyc=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5e94a057d9eso1636389e0c.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792419829; x=1793024629; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ynTwWaih3UWb7VmKOqAZKdwwEp9nTZ8YKOhE35tWuk0=;
        b=RBFG6/840RMJwuh4As5L3Nzwq4RgNwzfgSg2oKLIH9+4+7FqqBmUdwvyk3XS381zDU
         nhszGqNPvADlMuQEC5kdZ7jwIlwpHNSgGRGjM5KSWbAXwzhJT07330yR7wO4jJsbato6
         eS7gCaZX5H3LUS6S0hp35shyZEBggiRbNR4bAmzb32gQvqVZu7D09CstLcLE6I9QdFpp
         X1/wUuM3EPBWr2H37pwmxffwAaAbaqmK8A4S+Za1SS76F36qodkZOqKf6R2IWZ4aek8D
         tQO2g5QfgCq18+oD54NP/Izevw6COGU0bfxLesiaaVljgY2tg6qtppXHfD53evMOQpq5
         0kTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792419829; x=1793024629;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ynTwWaih3UWb7VmKOqAZKdwwEp9nTZ8YKOhE35tWuk0=;
        b=mQzl3RoZVHggDOfMy/WLPgUHRfouPQ09ifrINbO8oANBn4VJTNjbRsT9cU0GIVK4BU
         T3olhMWeLjWZX4b64RQhLstR6oXnuS56jRuKTVlFjD75ps8lvZokLJcp+oKLqwXz19w9
         1omBJ9QYzagOcxrchKCqEVTUAhoTlE0Bxgtsxk7QD145CH4k0st3TGYehcHoKINBCRzk
         aNotC9UT0fvemWrqtc8qbltw3kdgPmGwAsrP4H1SGFi8qCqekeIe+ouGiMNeBRIV+Ey7
         ZP4wh10Hwup9fyPkbfJ9SGq3FOR2X8WXp7meQj8HukPpCY7gfdMEL13bvN7DhOLnqNL0
         vjPQ==
X-Forwarded-Encrypted: i=1; AKwUvBzR9zuK2H2KkwECK1HMX5DysFR7Y/FQVqa6TCu2Q+U90DIKwzrUPIiuv05+p/ftkvf+c93ndnO+kQ==@kvack.org
X-Gm-Message-State: AFq9FYJYntL9yNzO3dmmdLCsOMBip/yL8HOnCRkIwzYYGqGtuKwaRVKZ
	7uRzoTu+eMX8UHlEo+CZ6O1esFu8809AX84q6BnkEuoq1znxp6xXX/6p/X67Yezss4s=
X-Gm-Gg: AYBFou1vJ1kjm9Tn2dHTqg6vgErAduZkuuWFzF5iaCm66ipDSPMNeAfl55sRk8g7xT+
	SU1ojt9rxG/eEPFx+uldZUun/bXPH63nybGYcpvZ0z5DgzbH6IjeK5qgpyMJeO4R+zNcG6XEAm/
	ZkTA0w3fQpwa17j8Vdwzox2FkFVGbM1LA6zCFN6AldYvwnZYVE73DVR8JmAx8V+xgBBRrquPLT0
	3HQHCMd4VC0mHOiPI/vPlUTWX/waQJAIQWv9TOPyyFUO9D8GeyyF+W2CJdXmLuyGCtPJp0zqn63
	yQzW6j71EiqFRTTez4UT7CyoZWEltaKnO445UiQlaQ3nDCJJbzLE/eLf04X9z+L7oUCKAG0qIit
	NZ6ZvCHpazoyMQr0Dn/qJnb0NVptdt81FO4SJqJHrqPD06ymvbjtVhrnGrvKWupdICX7I7cgPS6
	O0c2L9p0YjkdUUTbPq10vSOzoV4M/ZZWtYHbyyrBsNyHyPP48Ug4ewD0C00vCbeEPO53OiS7S9C
	2Sq6EVswBWNN19I5Ige4uDtPmyzbpxUj4OYq1N7XFVZScdxYIcFHMRXq/iQXUmrN8a2WRb0i28=
X-Received: by 2002:a05:6122:6d10:b0:5c9:c60e:3a48 with SMTP id 71dfb90a1353d-5eaaa941aebmr2358171e0c.20.1792419829096;
        Mon, 19 Oct 2026 07:23:49 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabf0f70ffsm4885498e0c.16.2026.10.19.07.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 07:23:48 -0700 (PDT)
Date: Mon, 19 Oct 2026 10:23:47 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	linux-kselftest@vger.kernel.org, kuba@kernel.org,
	enelsonmoore@gmail.com, bp@alien8.de, shuah@kernel.org,
	david@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
	ljs@kernel.org, mhocko@suse.com, skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org, vbabka@kernel.org,
	dapeng1.mi@linux.intel.com, linux-kernel@vger.kernel.org,
	corbet@lwn.net, surenb@google.com, kexec@lists.infradead.org,
	pratyush@kernel.org, rdunlap@infradead.org, elver@google.com,
	graf@amazon.com, lirongqing@baidu.com, liam@infradead.org,
	jlayton@kernel.org
Subject: Re: [PATCH v1 0/8] kho: add read-only Kexec Handover mode
Message-ID: <atYn87kYpuIhRxLP@google.com>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
 <atXYMK5tmW8f23gs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atXYMK5tmW8f23gs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 137DB1C0003
X-Stat-Signature: bwd4bymb8o41mwqg5as43rqckaasmg9r
X-HE-Tag: 1792419829-861817
X-HE-Meta: U2FsdGVkX1/5hcIUvhCDDL/uXN2pWkgPji9gQHh1kTk0mr1Pdxk9b0aVTdnoIVOeJsAhTiqBgqauNNt+DTTi3zhk8QUFbZhrIzi7f6VdEAl9l+0Cy60WxJ+5yUdtzYNp7KEWTel83nZ8b/N1UuiAC7PudB9Sol3bmI8g3UhHdQ1GdaM8PGCxdhBZNuuOGNFe2DMqCHlwqRH/nkIjq7mN4uKtJI+DLQ8wAaMMc0EEui6mocwTMNggpfpHO7fBlZyqyoA6NnWtjGW6Rsv2ASAeUv93CjAfg+wtrTDUttBxAwFNXXXV44tCzNMTAwgv1C3f5tysDpBANHVf6EtNM5BvbGSTH1AvA937qFT9fcittszXE+YkCqRURZm2ubBJ9QYr1EYKZbunjNQ+82ZfTbhm4yDMEOp4z0n3VkVH8P6J7y2KiwvIG5PLB/Db2AexzAgM11UnjsQf6s9EsnzFAXGYzu64Pgx3pDK0fU6oxvqaq23YrWV6l1nISNLArZqzuzgghI7Cu4Bgl6XPFIxC2cUvXjLqEDjmZ/DbTUaKFe08jnN7XDl88RcfhkL/2HbyUpQl2ZaXJOWrtPUjIo6+7by6igOCVvqITudxhZiCOnDe96+9TaEwtxckXQ5hklEtQ7uSaEisFUi62FqjMgat8BOHaLFQx6dVrV+kgz+Ci0R1vf7gcdiKsGdC7oi9UvuYs3GSjZ1eGTcYKnEwXPMeYvibRycHyecivAet+9S7W3OnnVPcosq1rvffJyKdL+YEX5ZLcHeyuzewvXkqpWBWpLNPKEkUnsMjqh+7xvTS42OQHm9ITTGb96pXurnIaUj0o+gbUXlcHkTjLqkPCyE5JitIt/VQZo+jpseKAcLwMPa3NxAmoYBWFhPysPPy2Cuy4zPSgFX/NE/kKAwfEP4VdDDiwNvhfA6OliKi7eEefEt7qkNqAdOgmlUAhnJX6mEODKO6NFtqnPCMafrmPFvHs+e
 YMY5tKoB
 wkWfnTrOQM1K04Ie6HM1dVzrUR6uMVYOIN5T0w1/Bf65LAW/kWAA2hY1Tc08sZF8WZ9xdfpUihdJrpLkvWphWS3WlDdkYU+hCspk9jzmoD42xt/toyZomuqZKXSkjtD4/xXYrcbYCJIAeJmR5EpcYZ5B7R1TIJoep2RvsIgngLnBb2Ww9B3E+mbFuSCCQut5wVvmoLxRCvzkfLsjmtPQmJ8Wsm62AiNNcb9LzlrrLY+L9ndL9LxtWOB/Gl9BvKn/vIQweqcZYGhLTv7KxBTV90M6WMKu/jB0/MV87PAAr/TE/tI5NYdZ/aVPDOPJ6UxMgarkQfS5qoTDAF54Duz22/aA12eGpb5XTxoI4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10-19 11:43, Mike Rapoport wrote:
> Hi Pasha,
> 
> Some brief comments before digging in.
> 
> On Sun, Oct 18, 2026 at 10:11:03PM -0400, Pasha Tatashin wrote:
> > This series introduces a read-only Kexec Handover mode, enabled at boot
> > via 'kho_ro=<pa>' pointing to the physical address of the KHO FDT.
> > 
> > In standard KHO, the target kernel takes ownership of preserved memory
> > during early boot, initializes struct pages for preserved folios, and
> > reclaims KHO metadata and preserved pages back into the page allocator
> > as they are restored.
> > 
> > In some scenarios (such as a caretaker, inspection kernel, firmware), a
> > kernel needs to inspect and consume preserved KHO subtrees, radix trees,
> > and serialized metadata without taking ownership of or modifying the KHO
> > state, leaving the preserved KHO tree intact for a subsequent kernel.
> > In this mode, the KHO physical memory lies outside the kernel's direct
> > map.
> > 
> > To support this cleanly without duplicating KHO traversal logic:
> > - Patch 1 exposes the physical address of the outgoing KHO FDT via
> >   /sys/kernel/debug/kho/out/fdt_phys so userspace tooling can pass it
> >   to a 'kho_ro=<pa>' kernel.
> 
> We already pass the physical address, why adding a boolean kho_ro is not
> enough?

In standard KHO, we pass the physical address as part of the normal 
kexec_file_load() reboot path. In that flow, the outgoing kernel shuts 
down or serializes all devices into LUO state, releases machine control, 
and hands over all machine resources to the next kernel, which becomes the 
sole "Machine Owner" (MO) and owns all machine resources.

Here, we are using a model where a minimal "Linux Caretaker" (LC) kernel 
runs concurrently while the MO is still active. We spin off LC on 
dedicated CPUs that have been offlined from the MO scheduler, giving LC 
read-only access to KHO so it can temporarily take care of VM while MO 
undergoes a standard KHO-preserved kexec reboot (i.e. Live Update). Once 
the new MO kernel boots up, it takes back the resources from LC and 
retrieves everything normally from LUO/KHO.

LC is never the machine owner: it has no PCI support compiled in, does 
not handle device interrupts, cannot handle page faults, etc. It only 
exists as a temporary caretaker. LC is booted entirely inside a small 
LUO-preserved memfd area (in our use case, LC's RAM is only ~128MB, 
while the host machine has terabytes of memory). Because LC's direct map 
only covers its own tiny memory footprint (for isolation reasons, and to 
save on struct pages), the KHO FDT, radix tree, and preserved VM memory 
all reside outside of LC's direct map.

LC is configured and launched directly from userspace while MO is still 
running. Therefore, LC does not receive bootloader handoff data from an 
outgoing kernel, as MO is not even shutting down yet. Userspace 
therefore reads needs PA address of KHO FDT and explicitly passes 
'kho_ro=<pa>' on LC's kernel command line.

> 
> > - Patch 2 moves the shared radix-tree key encoding and indexing,
> >   vmalloc flag conversion, and FDT validation and subtree lookup helpers
> >   to kernel/liveupdate/kexec_handover_internal.h so they can be shared
> >   between standard and read-only KHO.
> > - Patch 3 hardens kho_restore_vmalloc() by introducing
> >   kho_vmalloc_validate() in kernel/liveupdate/kexec_handover_internal.h
> >   to validate the preservation metadata header and flags before
> >   restoring the vmalloc area.
> 
> The diff for kexec_handover_internal.h 
> 
> >  kernel/liveupdate/kexec_handover_internal.h   | 171 +++++++-
> 
> seems a wee too large. Maybe some of this should move to a .c file?

Agreed. I originally kept them in the header as static inlines because 
they are mostly small bit manipulations and helper routines without loops, 
but moving them into a dedicated kernel/liveupdate/kho_core.c is OK.

Also, for v2, I am planning to allow CONFIG_KEXEC_HANDOVER and 
CONFIG_KEXEC_HANDOVER_READONLY to co-exist in the same build instead of 
being mutually exclusive. That way we won't need two different kernels 
for vmtests. In that model, common KHO API will use function vectors 
dynamiclly decided at early boot depending on which mode is activated 
('kho=on' vs 'kho_ro=<pa>').

> > - Patch 4 avoids modifying ser->next and bs->head_pa in kho_block_add()
> >   and kho_block_set_shrink_one() when operating on an incoming block
> >   set, as the chain is already linked and incoming blocks must not be
> >   modified in KHO read-only mode.
> > - Patch 5 adds CONFIG_KEXEC_HANDOVER_READONLY and
> >   kernel/liveupdate/kexec_handover_ro.c. When booted with
> >   'kho_ro=<pa>', preserved KHO metadata is mapped read-only
> >   (PAGE_KERNEL_RO), with the FDT and radix-tree nodes mapped lazily on
> >   first visit and kept cached, providing read-only implementations of
> >   kho_retrieve_subtree(), kho_restore_vmalloc(),
> >   kho_ro_lookup_folio_order(), kho_ro_map_folio(), and kho_ro_unmap().
> 
> What are the expected users of these APIs?

The primary use case is achieving ultra-low disruption Live Update 
(<30ms VM blackout time) while running a minimal VMM inside the caretaker 
kernel. This VMM keeps VMs responsive by servicing software-only, fully 
virtualized devices that do not require host hardware interrupts or global 
machine state (such as virtio-console, pvpanic, virtio-rng, etc.).

Thanks,
Pasha

