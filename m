Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69652CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73056B0088; Tue,  6 Oct 2026 14:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24686B008C; Tue,  6 Oct 2026 14:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12386B0092; Tue,  6 Oct 2026 14:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7F46B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:02:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA1BC802D0
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:02:29 +0000 (UTC)
X-FDA: 85292971218.18.D985313
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf05.hostedemail.com (Postfix) with ESMTP id AF02A10000B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:02:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=iXCQQb7e;
	dmarc=pass (policy=reject) header.from=canonical.com;
	spf=pass (imf05.hostedemail.com: domain of chris.bainbridge@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=chris.bainbridge@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791309748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VPKoVET0WZyi57RaxQihc41cTq7wyN7m0LKNzGgdxA=;
	b=OGM+O79uajWCr6IpYd3qnhG4fm7uKGAz3Qu3q25nCrafaY9fb4x0rFqlg/JX0yLhkad7z3
	IN+HBSrIj6NIYGL3UxeeRxBytM/JGRgdBWKz65LK3D/opjvL8gOVVVYCJyE5MPuusj2OuI
	s2S7vmS2bRtSWI3UEI3GU3GEFZSgMFo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=iXCQQb7e;
	dmarc=pass (policy=reject) header.from=canonical.com;
	spf=pass (imf05.hostedemail.com: domain of chris.bainbridge@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=chris.bainbridge@canonical.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791309748;
	b=NB6xS7w/AzfOkCjcRa9m1MqnT9e/5f+lxt9GB7h+w0hWSMirqGVP2/HCRH8w7yEOFfCl/g
	pAGgjyHZfn0V9r/2mkbrIETT0CcOuo++eGhGw5BbQrb8ASNHZawYhlQwjPhKwalzmPOsBd
	kMvzR63BBNl3HX7CrWDVShhJ5qZkc4Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E50A63F4BE
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791309745;
	bh=7VPKoVET0WZyi57RaxQihc41cTq7wyN7m0LKNzGgdxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=iXCQQb7eMUz6yrDWGGHjys9Hk8X8xESHiDdK6/Kw1dF0MeM+QNScH5KwV3Jiru7uF
	 Gx3XEEURkz68rqkJCfMU1u3x1Su+wX0EDsw8ifCOQsNsa9VrZukipeU6EbpAM33eUd
	 qnhBTHGGTwlKTqDva5gkhNAkYXEdKyHLP4BbTmeJo4xOImkJhWuSY3exE7Fr9biCUh
	 7+r+kaLSsAcg6vTymSB7zs1R3Ss636pEAaDQMCAzBn8HLz46MjGk9n0mgAZx0sE1Kn
	 q+0nQ6Whk8vMUozrz6XRNfAWeVPcVQH8L0lbWjbdmD/ea9KIUaDs9BSvoiWP0c0h7m
	 B/R2HL7ZZMV8Tez/1Ir+ul61vzohbnvEgHf9i2D5U4FEpd3M8K1Esncvoiid/2E0fg
	 z/ICOAD8F7rGui87lERnWMc+KiV5MQGvYwoxpW5BbJKt83cfA5DmKkNE6WHmfc5bpp
	 DIADmnf2lu8n8sIfIeV46b2gryI1Jdr9QwHDKEOQRsMe0CSddmP5AdP1CFfKqfFLI8
	 eX/Xq9fqh3ItsxIiUovEj5BmNs2Yf0Ve8RAlkKPKE2V2pZs/QY904cEBjyjTlV1J0W
	 ETrvoryJpNi0GRL5jnjwsAwtQZga0m0BRszqa3yLo0yjYun4oD3axrKZ4O8eVbLx5d
	 WHABfP7ahaGTatWHcyCxsSO0=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so24570185e9.2
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791309745; x=1791914545;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7VPKoVET0WZyi57RaxQihc41cTq7wyN7m0LKNzGgdxA=;
        b=T5rRyqiIePkDP0dcceld2lJVGDQn4FSNLI00lNIkJBWOtajNOXp54mPccm2CWG5XiW
         qj3msgRcECmlPAEmd/2qa+25qncBrcQcB/zuz2yxI80ikkPHGhYwbzZV06p3C+0G1+ol
         nZdREuyXWL7xTZrH5fA8kVgvt4VPF4p6ZcQJ3h4OVmf0y3MA6v3DTzetJtR67V0hMKhA
         sgpcC5YgpYbG73meI+NZlytDCraTWXwz0KtvZFHBQ5gyIsUQ3sJJhYy0PK/OBWsInaOM
         rPTnZRZoEdpS9xA4HaaJO53XU9PidA9WfLXjheakCkESRZ2WnvpSr3BUK3uxRqwd3Zov
         ZxyA==
X-Forwarded-Encrypted: i=1; AKwUvByoI6yuVLbxQv7yeCFXxMLsnqONYQVipYv160e4SAKY6rVi6ylxj5opAQsTSdADo/STfAvOdH+GNg==@kvack.org
X-Gm-Message-State: AFuF++lcWVqCtpQI4k0xTaN5ve4idWiarwn1wY54h0isI7aoNjzHpwf9
	ym1Rc0Q6m+AGPjsfVAlP5ytEEXaQrgmphiwXxNP1CM5ENTWvYALEo0jKndcIfoK14Cf0puen6tB
	qwfRFzsT4xAgOwnDIT5zYUVc0Z/EIqd0vFBfG0CIyeeSWu+qJ7bVrqABKcdbagZ0rrQbP
X-Gm-Gg: AYBFou0pWHFFAeKyMXMOVom+5H/i4aLenLpzSICQr4WEQiZYxZRUjWVsSj9mUUBG7w5
	hSzRTc7DteJ7Scq6xai4wXO9ivgGx6GfyR3tfU0wc8c6u2RimFAJcjEPxfFloCYlFC6ByC6qh/H
	43Bfmppd5nPtNPCz3GO0FmnwG1lDiXh4DkEhYy/pfUbhKL0aeUukOWwkTDPCi1k3x+NPtJBVqZq
	vF63UA6jWjJgTFtJWIbHLoxlTBOZRKYEpW+CZD+mTcUuaSj8dma0MeQ7DUPqSJB/49zJkRuczy+
	dA6Xr/IP28aVj9HmgCehfkxCh7pv+QkPR38geciTSE+iFMOK0PdwNjJi9RyFv23mwvN3/pnf/AM
	8Kln9fco=
X-Received: by 2002:a05:600c:1c16:b0:4a1:7832:dfd6 with SMTP id 5b1f17b1804b1-4a17b5340c8mr40388855e9.5.1791309745298;
        Tue, 06 Oct 2026 11:02:25 -0700 (PDT)
X-Received: by 2002:a05:600c:1c16:b0:4a1:7832:dfd6 with SMTP id 5b1f17b1804b1-4a17b5340c8mr40388535e9.5.1791309744934;
        Tue, 06 Oct 2026 11:02:24 -0700 (PDT)
Received: from px13 ([2a06:5902:822:4600:6f35:9ac4:c6c9:f701])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f493761sm5540315e9.2.2026.10.06.11.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 11:02:24 -0700 (PDT)
Date: Tue, 6 Oct 2026 19:02:22 +0100
From: Chris Bainbridge <chris.bainbridge@canonical.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Jason Miu <jasonmiu@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Ran Xiaokai <ran.xiaokai@zte.com.cn>, 
	regressions@lists.linux.dev, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Subject: Re: [BUG] KHO handover hangs when memmap reserves PMEM
Message-ID: <asU2AD6DxGSD0ek4@px13>
References: <asE0R_f2r2TL-3Sy@px13>
 <asTTo3AFzQoqZLoP@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asTTo3AFzQoqZLoP@kernel.org>
X-Stat-Signature: 44k4kpuuz3aqzobq1hsmzufg51jttodz
X-Rspam-User: 
X-Rspamd-Queue-Id: AF02A10000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1791309747-419802
X-HE-Meta: U2FsdGVkX18CRGHwgB/OJdATZPzy2eDADgIjwLv6S2oysQKtoHgq/gQ/Sc9+Ha9udWEyXtIYd3s4mzseQn0Jrh2tmoE8s/Yak+zZ2V11ZkuZ24X6mQC+Rx1uaOFcSsEXE2eAtZqezFrfILPePvSjt1eet+eqtTiB9e3slpYQVix8pZ9ekS/TAzy/zV8JbjmJ/7UlcDx0bWNgfRScby/cc02E5L2fyDU5ZvzA+7dO4i5oRp4VxHZs277vputun+GM2B6GQ1eFs26iOjdnsdRxu3/Qwv0pRx5vuzJp4ttSiBxGFIy2w0J5cMY/wdYAWyTAf1pdPgDOHrMIYgKa3CYsyyB7g9XOSVbuL4HW5gAwBoamk52oj9n9FXM2jyJwaIHPP8/NMZ1QL9awejJExtIx43Bd0vzHgohtAqZZfaqtQbpLsfoy2XnKI0KtLqLge1eOITpsG5oA5y6XcdbF3S4jC5Ta4oGQvG0obKqJ9+9irPWyaek94dPwhklTIoNxwfY6DNDK6mw+hIqDWI7Ds848uRdrfG9qTVkblRn5CaOiRCTlHeTO/09b4W2XU/D+33oHhqkUIbdXZ4JSYIbbqvDXdLLnr+PZWnoTKVwRlvH3//HX2MzBPVFt4Htv0gdf8oI9L4JDLQKNL3YnPbbYmzDV1l4Q13/cWxxoewtheuoiJNGmUexOUvXA5gFP+MI/wywKAJaxdY6SvBM3PeRIdodfqXcZYn+SYF/JWsigyYyjRlOtypWfJV3Ozl1nKpr3yIbptzNiYO2EA7Zup41NPRkPK62uk8i955a2cw02VjChYibGdJFfyXxTnMSUVDT/PVx2RuehhlGS7DWf+sHqYxJSKERPggxWkp7yH44Ga82mDDoR7xVWKcfPJ4LfZ3OiYO131kwOe/OqSsTiH0Tn3Nkax/xmdeqPkS6hRLj2PvTUzmqdBGvV8YNtybuFZ11JaD+u0yfFfxZAA6tmuOirXAg
 TwEGR5oU
 f1aBbFSTVXI+ReRoWjZZ0xYy9dw/d3J275qiVi3/Jo2el1Wf/BgKZaRJWmB332xcChiE2JbnW+80sL7dBLsCR6xsWax9XmkwvLOVQW5RYV5xEkWi5MCvD6COxihasHw8g7c9GYHdlZtGCfawYOpxu9KTO16SNgVaKHaDI0EzIm/roqxDSjtw7NZ/0M+dzgT8n6zO6AzZ9yqFog0SKLEc7mus58W9nNwiNDjFtFOTdHuBO0cDo7iXpCbkAWbQKv6XaN26ht//qKdAJXXddnxkMHhNJ2RF0OmqjFu90VZ/ZMbtow2XVLAQ0ra3zSeNd8OsfGHkS8Q35M8T5AoWLpjyiI7rvtRwcrxqfQdTipLeyAqq6BHoShp05LsIRxSBqGC0uOCZYQQKa1yCYw7IzbAFvaMej6kr0s4otqBAV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 12:55:31PM +0200, Mike Rapoport wrote:
> On Sat, Oct 03, 2026 at 06:02:27PM +0100, Chris Bainbridge wrote:
> > Hello,
> > 
> > I am reporting a regression in KHO handover.
> > 
> > In the most recent Ubuntu 26.10 beta mini-ISO releases (2026-09-18 onwards),
> > the first kernel reserves RAM for the downloaded ISO with a memmap directive
> > such as memmap=<size>!4G, then kexecs a second kernel. On affected kernels, the
> > first kernel reaches "kexec_core: Starting new kernel", but the second kernel
> > produces no further output and QEMU spins at 100% CPU. On unaffected kernels,
> > the second kernel starts and finds /dev/pmem0 with the expected "Persistent
> > Memory (legacy)" range in /proc/iomem.
> 
> TO make sure I understand this correctly, you enable KHO in the builds of
> the installer kernel and then the installer command line explicitly enables
> KHO.

Yes.

> Is there anything you actually preserve with KHO when kexec'ing the second
> kernel?

No. kho=off is a valid workaround for the mini ISO. I only reported it
as a regression here because this was working until the bisected commit
was merged. If this is intended behaviour then it is not a problem.

