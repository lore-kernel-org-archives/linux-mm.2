Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DDF3D58CBE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 03:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42606B0088; Sun, 22 Mar 2026 23:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF39F6B0089; Sun, 22 Mar 2026 23:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2696B008A; Sun, 22 Mar 2026 23:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B787D6B0088
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:23:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F1291B8C30
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:23:49 +0000 (UTC)
X-FDA: 84575883378.09.5A24349
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3115718000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:23:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hMXAhlkb;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774236227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WuN4IVRpe2UV4/L8jmgWKZsUdAcN2rX2txKuBjApf3Y=;
	b=QLsPQ9NNz1dpB70OwhheCfOLk/AhjBClncEBmY15MEF69r83Lbfd+dlenxs6GHUIUkPMRW
	DdLty5QBqSAytc42WKmE8hbi554vm1uY5L3WiL0duJtVLj7e0jC8U1sX+bg4zJVPkh64VV
	5+lnuKbAgawv8GwLZ4RIF0GCPd8l1jY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774236227; a=rsa-sha256;
	cv=none;
	b=4zvCpd1tFUXbEQ7T9exgY0S4EN+fymzPGk2K0jCWUP/3k+hSNW7tDqBD+Ojh0ekijXsVEq
	CtfGq6YfUZE5lMjwwXhJ07TyI076SIJ3rG98eaWYDl8S/S446G2hAVe0eEWAYKGRTp3tKr
	FD2aqLOr4u/1b/d2rWqEvaPeyYsG/Ms=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hMXAhlkb;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774236226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WuN4IVRpe2UV4/L8jmgWKZsUdAcN2rX2txKuBjApf3Y=;
	b=hMXAhlkbSiwZYJUSMgnQfit9umI0POO0KUh3teYJ6qgY+oF8q1pU5jCFbM8XKEP4+wmjAh
	k6o02s2kYaXSESON2uB93pY5N/wMOdwhw9Ri1uhfUY9xqy8+eGpITpztczkj78ba8pLZGs
	L7A0Gy+fz7WRk5WNVl7Vz16XHvXffPU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661--iqGfR4dPRqxe6JicJ1Vsw-1; Sun, 22 Mar 2026 23:23:45 -0400
X-MC-Unique: -iqGfR4dPRqxe6JicJ1Vsw-1
X-Mimecast-MFC-AGG-ID: -iqGfR4dPRqxe6JicJ1Vsw_1774236224
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c73c065dd15so2546916a12.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 20:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774236224; x=1774841024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WuN4IVRpe2UV4/L8jmgWKZsUdAcN2rX2txKuBjApf3Y=;
        b=Z8EFolSJjdyiSnaLHjGbVlNAMpqvQO8kwO0IuCzqaRPIKEJbuB1Wki5yUQXrvUCfFo
         fcDgoLBVKRz52YRim2ZNX3jgW+Q8Hx9/DEwLRCqbAaX+1Qed1dEBkX3SmNBhC/suh5qY
         /fPn+PleT/HnbhhYqQqrdRUixZjRfc/R3+Robw8schL1I8PFElKHItL2O9ccyfDM1OwY
         aM5P17gP6Hp3ZLavRXBdpxGrZaOQ46oVge86L9CDzTffAybwpxIE68WsvgCuNgnurU6f
         U8SjG0fGkNuUPWDIqiK0v39rT85sTMT9Tc61kwm7oI+fU9hsjl+uGilt6SAJaaom1zih
         OYhg==
X-Forwarded-Encrypted: i=1; AJvYcCU7b6amuFqd6WXekztPXYBpx05ojP/Dl0tISKerwY3/TFtucMTWz84WJRiBOG/Ugi/Tkn4v35mCVg==@kvack.org
X-Gm-Message-State: AOJu0Yw3Ms5A5CjRzsWv71PyDxB5EVfvp1I0F+5+LPDNxoY0wJJzrUas
	YxZwjR6Dnc3meT0EKibQXpimMtvwjdKdVVNzhZyEnjBIuhug9r8K/NjJYKT4KTbjgTs1X2ix6kJ
	0G/s4IPPc/PLMzIqOGzFMqH1/Dzo89igeH1JHpsDz4LchJ1A1UT9B
X-Gm-Gg: ATEYQzwHWooVOeYEfzfv7FS0siAYudfwKoGLu0VwldZVh7F4Ie7By/lU52Tmac5/o++
	gVkyisM+cn5KZKi+tyg95JVBAmVRqMtuOdSFfgtWRKI6uG3hPrTCU10cMlfcKAjj5NBF9bZVyC1
	fkL3WcIYARNcAf0LBp8cHmfppRc17cQH1rakMhZ2SwQxDum9XzBl3dTXu++z1AaZHKjMska71Vn
	t0nNfOsFfZ7uKBBCMsvX8/rob2YWSEIwkZ1eHDCaj30t5vG6kOB1uBKELoU8CPmeprSsRdOO7L9
	QK27nfRN6RZeP7IYi3V1lg1GoHydFonltzI5WH9T6t+v0r7pwMo4nMeY56Zprhgjq6rJs+dDEjq
	Xj9HmsnkjXhx0hvqdrA==
X-Received: by 2002:a05:6a20:94cb:b0:398:d82c:ae6 with SMTP id adf61e73a8af0-39bceb427a6mr9147199637.31.1774236224294;
        Sun, 22 Mar 2026 20:23:44 -0700 (PDT)
X-Received: by 2002:a05:6a20:94cb:b0:398:d82c:ae6 with SMTP id adf61e73a8af0-39bceb427a6mr9147173637.31.1774236223867;
        Sun, 22 Mar 2026 20:23:43 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443ccbe4sm6215654a12.22.2026.03.22.20.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 20:23:43 -0700 (PDT)
Date: Mon, 23 Mar 2026 11:23:40 +0800
From: Li Wang <liwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com
Cc: yosry@kernel.org, yosryahmed@google.com, nphamcs@gmail.com,
	hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <acCyPNCBoTGAJjfs@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
 <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jyT4P_80uC49EplGZ9mBQBp6PP__psrq2XhywoWfAuU_1774236224
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3115718000E
X-Stat-Signature: 94ch67weabndf6fhc38rsgoyficghnhi
X-Rspam-User: 
X-HE-Tag: 1774236227-99757
X-HE-Meta: U2FsdGVkX18qRxXT7LhlFarLqwAFZE3v/pZVF32ziqn5H/2ufP2dJjs5SW7Uf4XPhv11nw111MSkdJJtjzYbJIZWaHMSNQulQ7e7iKql07iXUUtbdKROLDqTSfwveIsJyDZcKOD5bzOp63ERq1Ug22PukgQsT4hIakAFevkGkUsMS2D0OHNiuneq4FUA0F84JkmX3x4TpUnTtvVuH0AnZvjpXzvfMVWYA2CFkehMR1WcJta1ZtVm2DGszOv8htUnV8/0r/hEcmDe3nRW0WMT7aVAwIQwiAftnSaq6PPsy4yKH5kz8cdB9XiRDm4fwyn86k7MmqsXBUqocVP7U2nU2NxFjJrB0jgRYF9uvMI+MqNocVTGr62Ax+WKAalTMe5ieqmYXsbB9ZVnmAdm4jg+XnecQsrgAphyTOAMyl9igwgwCldnOxAyGfN03rLxBNUAXJO3sQ3MqEBUGNvtBK+CAf2RNg6HLc3EfPhYDRYXlzyvy5AKlIOXVhGwXCSZ/cOxa0Aj4Pm6rQ6l3ccH0eMO+2+ZhYEngt0ovSVOTCIz8sxUMi7n6DFCbtaDIHta+JQk8t0tHQcqH/+SGYVdEu/MnzgNzuC0nIYEmQ3Hl0wmDIT9jWXgzZtql+ss2as9ztRCVe1xMTETKSEVwSfMHZtG+qgvRErgDR3oCX8JLi+/0CvzakzErmXYF9jgJNCFJsg2xVcpdtkqvqPW4iOv1H65EJMn/ajOWwF89vaD/uGpDCp7U79EoWCYTLniZ48NdUwSNTLvmQtLPga6aiJEBSqzmXf/9GbN8hxZxfJNHocojoahcEzJnzgP4FPcIrkFzrrwbPPyuMZbGmFOCwr7LfMpRYrwvKf7vi30uQYrLG3d6pjvxkxOtZ7LVNqXEfx7rJ/CQ2kZXMER67Wzv3HfTk47RKCPwtMCKR7nppckgI63Vwsji0rGQWMND+f3yqvIUfKiMHCmQFKay2HquIgJ88S
 6BCa431b
 QNy5lWuBxBJtvEH4GHsRIZmchTObwIqbT7SRjSJq1pqqHgCilEv1VrAhvgICBRbZ72PAvWCWOrYKzJcyCsH+JMvqcy3Fmi6d5gAsRBUKgo86FHOBsY9yQQ3tL66NTRmvwWoSbeksHCzuLKg0aiIA10npL07p6biGTqnppwON7sz9pEAuGvHc4qwTCnPwA1m6LYnobVIKkUYisCsq4wfF9341Gs09vDT8Wc7sNMtmC/R+xoTrYbyP+9eADkZSYpXMvQhRUXnvfn9iwyqNvWSKDCpi9ZeZdA4w/gAPGY03Qh7is7utDOx0egd0VNNXRO+17KPYmHKN24qV7psYM9afUaM3bT+MltKiOhOqm9QUqzfhp6ZNeMuFAG6Oenivh5FBsmEqI8li0e2TDDcS5QztwzQ0+AcNk5LBG41SHLtRHq6u4P4JUvbuXg0ANW/Fg45gEWuZENUn+IMFZ5+w4vlTOitcXXgVN6TTim70GuPH/DdTKNU+HNLXlQT7Y8UKU1ucIYgzr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 09:18:51AM -0700, Andrew Morton wrote:
> On Sun, 22 Mar 2026 14:10:31 +0800 Li Wang <liwang@redhat.com> wrote:
> 
> > This patchset aims to fix various spurious failures and improve the overall
> > robustness of the cgroup zswap selftests.
> 
> AI review has questions:
> 	https://sashiko.dev/#/patchset/20260322061038.156146-1-liwang@redhat.com

> [Sashiko comments in patch 4/7]
> ...
> Could we update this loop, along with the identical loops in
> alloc_anon_noexit() and alloc_anon_50M_check_swap() shown below, to use
> sysconf(_SC_PAGESIZE) instead?

I found that Waiman submit another patch that do same thing like this
suggestion. I'd consider to merge that one into my patch 4/7.

So, let me talk to Waiman first.


> [Sashiko comments in patch 5/7]
> ..
> if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
> Should these also be updated to use the new global pagesize variable for
> consistency? Subsequent patches in the series do not seem to correct this
> omission.

Good catch, that remainds should be corrected too.

> If control_allocation is NULL, wouldn't the loop immediately dereference it
> and cause an unhandled segmentation fault rather than a graceful test
> failure?

That's right, but better to be resolved in another series, not this one.

> However, there does not appear to be a corresponding munmap() call in the
> test's cleanup path. Although the OS reclaims this memory when the test
> process exits, should this explicit unmap be added for a balanced resource
> lifecycle within the test?

That's right, but better to be resolved in another series, not this one.


> [Sashiko comments in patch 6/7]
> ...
> If malloc returns a null pointer in a memory-constrained environment, the
> loop will unconditionally dereference it. Should there be a null check
> before the loop?

That's right, but better to be resolved in another series, not this one.

> The test data is generated by writing a single 'a' character per page, leaving
> the rest zero-filled:

> 	for (int i = 0; i < control_allocation_size; i += pagesize)
> 		control_allocation[i] = 'a';

> This makes the data highly compressible. Because memory.max is set to half of
> control_allocation_size, 512 pages are pushed into zswap.

> 512 pages of mostly zeros can compress down to roughly 11 to 15 kilobytes
> using compressors like zstd, which is well below the 65536 byte (64k)
> zswap.max limit on a 64k page system.

> Since the limit might not be reached, writeback might never trigger,
> causing the test to falsely fail. Should the test use incompressible data
> or a lower fixed limit?

If Sashiko suggests reducing compressibility, we'd need to fill a significant
fraction of each page with varied data, but that would work against the test:

zswap would reject poorly compressing pages and send them straight to swap,
and memory.stat:zswapped might never reach the threshold the test checks
with cg_read_key_long(..., "zswapped") < 1.

So, at most I'd keep the data highly compressible and just ensure non-zero,
unique-per-page markers.

i.e.

  control_allocation[i] = (char)((i / pagesize) + 1);

-- 
Regards,
Li Wang


