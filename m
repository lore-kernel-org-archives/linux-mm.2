Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5383EFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962116B0092; Sun, 26 Apr 2026 17:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC686B0095; Sun, 26 Apr 2026 17:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D7C6B0096; Sun, 26 Apr 2026 17:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 620776B0092
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:34:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE21E140564
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:34:32 +0000 (UTC)
X-FDA: 84702011184.16.8040505
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	by imf03.hostedemail.com (Postfix) with ESMTP id E7DFD20003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:34:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jgRDNfMH;
	spf=pass (imf03.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777239271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaKTyAaE5njWlrSRpOaq+xnYt0Ofwnonz8Dpdwbk1HA=;
	b=Rra7Vug1tHDfNtCaJNSu5DaoIJbnAMc9659Fi4wEwmT78PtXiR+tfA5Wf7dHC/1AwoW0QC
	c7yUmbVhzeCChJ+811GjZPzN7hxMh6vDUrJNzpaLqU8npsdU/8+YKantuUDIKiXEuAYNXQ
	7FiK56zBdrblhF4WwnHOEBh1UwfLKiQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777239271; a=rsa-sha256;
	cv=pass;
	b=hgmVn8X/AvbR2yBQAEwgzcNljUgF2dYKK3z5JOHEP9MkagXk6F9WHHO/yZtHidhctPWi+S
	pkJYz/Js3b5cLm4oaKlcW4wugB19TpfocM2KYVsx1E4NIDgJwyN6R06jBdCjjDgU9tjmfU
	UbmVA4tqR3oUG8dF+2t7FJF7j8gPOZc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jgRDNfMH;
	spf=pass (imf03.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-12c726f46baso11798287c88.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:34:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777239270; cv=none;
        d=google.com; s=arc-20240605;
        b=JrLkbGHMvI73kVdkIMazS/fYUO9dj4omsS98d8VxgAVXiCEbsLpp71e99x203xaXDA
         RadDEZ7z2bTn6G5zGNgwQVVknMslaqQLgHRWZ+t3Rdca6nFpBmi1yblXFPzQHYlhlnwW
         dH6YILGCFihU/WPtRhjJDP3Cf8KqosiNPJvoPO+OBuSB+AwaXDDl31tZ8Ot5cxmc5YlT
         pLYwKL3/yeljqSOe7EymAY69pfRriWpjzN7TwZYqzujayPV/Ec2liQdlSaYZHIrBFhgC
         eeYNP4VWeSGd33oz/YpqA5YfAsNT/m8Z4B7NmoHqRtM/BbCSfUyEb/YdYfccgx0C688I
         MKMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TaKTyAaE5njWlrSRpOaq+xnYt0Ofwnonz8Dpdwbk1HA=;
        fh=Yza0Evd0wYid8xi6LumBcF2+I9rDX+ohK0JF3Dfp/rg=;
        b=Nb/y92aZWqdmFXZqWfluPvQHQRvjMII3RAZlJ466eVz/8TR2AZanxyKG6BVLgEgm3n
         s83dRz3wOG32LCAcgXVDFfENWfFoSBVakQbsnXs0tf6dwSubpvweWiQiPcCyYyLV6jbw
         njdTnruegKGz0sJKXIcu3yLDm9DwP9kP1ymC89w1VAPoU5ZrxlWksc0jiy2y25+EAgZL
         mVxtVaGP/aH66H2Mxrtz7qdL3GZ9d3nAOmw5R7WUBNCzdFqz6qt2acn2McrDx7ENTUOg
         yV2m0pFdLL+8KMrS/BZ4fhbgnSquUcipcEJ9iRcvdYmyRGBPE1NvbWS3liqOMDclmhhv
         STgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777239270; x=1777844070; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TaKTyAaE5njWlrSRpOaq+xnYt0Ofwnonz8Dpdwbk1HA=;
        b=jgRDNfMHfN5zcPtZWtsFK5Nb0MkP0avKx7opamxwQD8KZ2a9P6rGdWoROmQgBFv/KL
         as+unYvrdprQ7mhrT6CiNObLsCk6tMZU8mdISt1PJAQ7qS1Qlhz1Qu6XAM8Irc6+GjX5
         reVAkBEWLfGc2cDmU1RDeLr6FrEcK1B5tPhHvKu1jTFNAoXzwGgGkIGXOwIy7Yf8h8k5
         Qqhw8GVBMZoqWQhA8hp1D0U0fXMD6OD06tAlkyNKUUkxQGku7RYm9DQ0AoNkgS1cVzN1
         2fPwbH8HttHKZXb91PoLSu3927sIbByDXktpt5NNr/vFESosJeyNkbse258ICaKp1ZVG
         CMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777239270; x=1777844070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TaKTyAaE5njWlrSRpOaq+xnYt0Ofwnonz8Dpdwbk1HA=;
        b=OzSmT9Mh00655EaKAzuM9qtX6gTUqOcDwxgQPEbuSJLhcjM/q2q8eXNX0nUGPMVQLU
         8heNYD2s5QttjbL26YKEwvtYxvKfM38Zk1CoMyACW8Bqd/293vC1Bu7J7yz6rcFPGBJ5
         mBnqHXx/RHD8ATMWLFKxDbREiF9oszKU2T+Ni3EVYvE8z0WPz1eCbIasX7dRG8b6Wlgc
         to8krx563PGb0k9mJ6fr+dsOfVwxOS915D9gWm66fp9R6rvNjJYKKIz0kRhtx8vW7lHV
         q9S3LnM1BpKbiWnY1gvU2f6fNmJpq35zLi7tQ8oaISASaFV/rGXSFcvh5njENZ3YrnLV
         rqRw==
X-Forwarded-Encrypted: i=1; AFNElJ/t7rlsVt+nZjn/ZQzWl+yxtpwUfnJPSslvHnCfolv16aVs31uh5ifX9CyrpkTLk4UmUbSXxiatDQ==@kvack.org
X-Gm-Message-State: AOJu0YwY59JzaO5y8dODsIOwiOscUBlTwUQmpidRbe4/McIC9ycz6J3S
	bGTdXud/UYecVtmV3xjAg/fkB05smgyd7ugBXf3Br7HmANvbmEP+ukFUceTHu6p5h6AnK+wmVxi
	5DMnuBxAby6HlwFx3g9tJEQCLcbLHDw==
X-Gm-Gg: AeBDieuIzbdShHNVdViVOjauIbD5pdy9GPxUNwmBLlcw9XZiZ6dx0kGTY2d4Yz5SqQR
	iHpElqdzNz+hO9QPkWF0JYoRNWBQUAIMSZWjeBnoJ7qJi2oE2nmJYySEB60caWwI2LQWjZu1hFZ
	q+ieHfLRAB0BhjLuVA/23X9gSZtQHjMey59RtQE2pykF276pbW8XWJ78LhNucLBY87luGLVESGX
	Sv3rumymHtjq9y3asyBJAnrXRpqs3erTpvE4Rg18CIq0jnyXC8gx3iJlk3vCzJ8mcOxVfskRW24
	oxtwvLT3x2SlMftra1qA+JUsPwwz5kInjHMYoikhtFGaDLTi1A==
X-Received: by 2002:a05:7022:f688:b0:12c:8f92:c6c6 with SMTP id
 a92af1059eb24-12c8f92cb31mr16334892c88.33.1777239269510; Sun, 26 Apr 2026
 14:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260426003245.2687-1-ravis.opensrc@gmail.com> <20260426171941.86007-1-sj@kernel.org>
In-Reply-To: <20260426171941.86007-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sun, 26 Apr 2026 14:34:17 -0700
X-Gm-Features: AQROBzDubMp7QfuC4Dc3-rPJ1yR-TE2i0vS80hEPb2W-_-1yGSxmrEhAmWcksJs
Message-ID: <CALa+Y14J3w-Drc3wtFR_xE75NX1QKxP8+riXx++a7RyPkm0OLQ@mail.gmail.com>
Subject: Re: [PATCH v8] mm/damon: add node_eligible_mem_bp goal metric
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E7DFD20003
X-Rspam-User: 
X-Stat-Signature: 34wqiqr18uxq1ufz5ef4itq9hcpgor6k
X-HE-Tag: 1777239270-238466
X-HE-Meta: U2FsdGVkX1/yfqNNqb2mkojnGyLS44isiCo+/EEZsE27YscgDP/8+PuLGQUBut6mzMuTz90zlN2DhCgRNTd8zIkKn2yI6xCrErMUy9UaNej4DY+F3FNmHCbVOOCPjW0Uqew6l9ssTusw18tZKGHmkbKQXoy5WnFoxjhHUDl+S0Mp5G8TbjbgOHuWKtxDF+nSXXPg/Aa8l5qeNHSVqxhzl4tyDVemtRnU3vFaPpq4U7fygwbowFLLpa5UjdLJRtm2qRpVUhwgKg1UNIz+MMCFPaVchRyC1c9gzB0Vhqx5ocQbL2gr3emBE1TpMFnT1PZKtSX48Qxjmq2fyXx0WKEJVETb8a0odg/3WEg51Ym9QAUBDu6y62rpkbI92uzcoCAWgBKYJ1VFhRk5YQzZTrlpwN1Y5kbeCn8uz70fFttiQoLlQ37Fyj7k6IG48icycHti946xDfdkiWgkTSL0DmMbq/SggE4gkIJYzzlSV5YZNgepDqjgT8uPnATSUS9omRvOCZEqPkFnNMbearM1FNpCwNkjd3gDtN0YDuzqvApkPWArDlWi782dnalfI4Pd3KcL6qAFTiFlrVU0fuu+Ia4Dr3Nbz84zooPljPyigiIzoJl8QEhLF6WIrMIHzPPAmKc9xF0JhTLuW+U3d5xK8z21nWP6Oq9VZT0ehF7UekT7+chlm2g2h9VeObCZGoxj8+8KE9HzK8r5XZALL60Wli0VxPnL4jemVlVik37e1YWbeYtNbDVTbX5cKTbPT58tWaUoWcCX+XcYx+/pIdzjgZn//oiq4a5V/m9am/ANTGGkesMtJ+H9BzQvEbwG7UYjUPkPBYylg1GzyTZaL+HwG7A1C1Q5aNu4RzZtcxrLUqh+fj0a8Lc47JkKLNIrJq8lh7DF11FWpR0Ru3OWIeOVvAjr0kpj39CPcGmjeUxExq9i/U49UYHGV2lVAAmHrgyFp5xb5oo9mvmgrP0STOnSSb4
 sFRv3QGB
 5ZV7XHecp3kQ1d1l3hHjZ+ONEV3WMhkC5Mak5G6AfgJX2rCLgToDpM5mFFkEi94zdaYTdmyI/pjfZmQbrZrL2TaoXNGN6Trmo83uxiSIQiEhBzMLGU+2y1OwXsY0XI4iu2GksjvPqSa0lf0BPhxMVvYFDeVw9kCChWts0lrJ4Pouk5yMRiUFUXLslEqRAP5UQ3XpTegZu3F99G6upYHGkdK8p3sB7K+N5IEy/Z/tWmll3eV45kbuZjpGU2cngu8HmbkJ6h2Ancls68F8g47voa84Hdti+Erl7XfJTJSesgGOdk+/wzMu9PUx15T4ZDVHK9SOGtYZ4ND67KqjyDPemoDmrRerpYMKJ5+bxTTGuzuENPnflLOrIrFhMSau/VUTKFD59jZPLngjM9j5uX7qV/VhhfWwns481RnMMdzjM/N4wslDOOrTbpwIW8Ax0QppBS86RaL6lSzo2YGiQFdirL9spoDu/N7/UBob42xm4BGDeQiY9SQuRqxwdIAw4C15LqY8pw6Sy4EkYbW4VfxKTkpnUH2xELRezfNAVpmyO/XMUTzysoKF7cKGec5Z8w/L0/kIn/0pvGHnKTXDSVWataG6En1Z3uWV9zmcg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 10:19=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> On Sat, 25 Apr 2026 17:32:45 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > Background and Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > In heterogeneous memory systems, controlling memory distribution across
> > NUMA nodes is essential for performance optimization. This patch enable=
s
> > system-wide page distribution with target-state goals such as "maintain
> > 60% of scheme-eligible memory on DRAM" using PA-mode DAMON schemes.
> >
> > Rather than using absolute thresholds, this metric tracks the ratio of
> > memory that matches each scheme's access pattern filters on a target
> > node, enabling the quota system to automatically adjust migration
> > aggressiveness to maintain the desired distribution.
> >
> > What This Metric Measures
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > node_eligible_mem_bp:
> >     scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000
> >
> > Two-Scheme Setup for Hot Page Distribution
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > For maintaining 60% of hot memory on DRAM (node 0) and 40% on CXL
> > (node 1):
> >
> >     PULL scheme: migrate_hot to node 0
> >       goal: node_eligible_mem_bp, nid=3D0, target=3D6000
> >       addr filter: node 1 address range (only migrate FROM CXL)
> >       "Move hot pages to DRAM if less than 60% of hot data is in DRAM"
> >
> >     PUSH scheme: migrate_hot to node 1
> >       goal: node_eligible_mem_bp, nid=3D1, target=3D4000
> >       addr filter: node 0 address range (only migrate FROM DRAM)
> >       "Move hot pages to CXL if less than 40% of hot data is in CXL"
> >
> > Each scheme independently measures its own eligible memory and adjusts
> > its quota to achieve its target ratio. The schemes work in concert
> > through DAMON's unified monitoring context, with the quota autotuner
> > balancing their relative aggressiveness.
> >
> > Implementation Details
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The implementation adds a new quota goal metric type
> > DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP to the existing DAMOS quota goal
> > framework. When this metric is configured for a scheme:
> >
> > 1. During each quota adjustment cycle, damos_get_node_eligible_mem_bp()
> >    is called to calculate the current memory distribution.
> >
> > 2. The function iterates through all regions that match the scheme's
> >    access pattern (via __damos_valid_target()) and calculates:
> >    - Total eligible bytes across all nodes
> >    - Eligible bytes specifically on the target node (goal->nid)
> >
> > 3. For each eligible region, damos_calc_eligible_bytes() walks through
> >    the physical address range, using damon_get_folio() to look up
> >    each folio and determine its NUMA node via folio_nid().
> >
> > 4. Large folios are handled by calculating the exact overlap between
> >    the region boundaries and folio boundaries, ensuring accurate
> >    byte counts even when regions partially span folios.
> >
> > 5. The ratio (node_eligible / total_eligible * 10000) is returned
> >    as basis points, which the quota autotuner uses to adjust the
> >    scheme's effective quota size (esz).
> >
> > The implementation requires CONFIG_DAMON_PADDR since damon_get_folio()
> > is only available for physical address space monitoring.
> >
> > Testing Results
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Functionally tested on a two-node heterogeneous memory system with DRAM
> > (node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration usin=
g
> > migrate_hot actions was used to reach a target hot memory ratio between
> > the two tiers.
> >
> > With the TEMPORAL tuner, the system converges quickly to the target
> > distribution. The tuner drives esz to maximum when under goal and to
> > zero once the goal is met, forming a simple on/off feedback loop that
> > stabilizes at the desired ratio.
> >
> > With the CONSIST tuner, the scheme still converges but more slowly, as
> > it migrates and then throttles itself based on quota feedback. The time
> > to reach the goal varies depending on workload intensity.
> >
> > Note: This metric works with both TEMPORAL and CONSIST goal tuners.
> >
> > Suggested-by: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
>
> Assuming below two minor things are addressed,
>
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thank you SJ. Will send v9 addressing these two changes.

>
> [...]
> > +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *=
c,
> > +             struct damos *s, int nid)
> > +{
> > +     phys_addr_t total_eligible =3D 0;
> > +     phys_addr_t node_eligible;
> > +
> > +     if (c->ops.id !=3D DAMON_OPS_PADDR)
> > +             return 0;
> > +
> > +     if (nid < 0 || nid >=3D MAX_NUMNODES || !node_online(nid))
> > +             return 0;
> > +
> > +     node_eligible =3D damos_calc_eligible_bytes(c, s, nid, &total_eli=
gible);
> > +
> > +     if (!total_eligible)
> > +             return 0;
> > +
> > +     return mult_frac((unsigned long)node_eligible, 10000,
> > +                     (unsigned long)total_eligible);
>
> Sashiko found [1] total_eligible after the casting could be zero on 32bit
> system, resulting in divide-by-zero.  As I also replied to Sashiko review=
,
> could you please fix this?  It seems we can simply remove the castings.
>
> [...]
> > @@ -2389,9 +2528,9 @@ static void damos_goal_tune_esz_bp_temporal(struc=
t damos_quota *quota)
> >  /*
> >   * Called only if quota->ms, or quota->sz are set, or quota->goals is =
not empty
> >   */
> > -static void damos_set_effective_quota(struct damos_quota *quota,
> > -             struct damon_ctx *ctx)
> > +static void damos_set_effective_quota(struct damon_ctx *c, struct damo=
s *s)
>
> Sorry for finding this late.  Could we keep the dmon_ctx parameter name?
> Otherwise, we introduce unnecessary change below.
>
> If the mult_frac() divide-by-zero is not a real issue, I wouldn't insist =
this
> change.  But, if we will make a new version, let's do this together.
>
> >  {
> > +     struct damos_quota *quota =3D &s->quota;
> >       unsigned long throughput;
> >       unsigned long esz =3D ULONG_MAX;
> >
> > @@ -2402,9 +2541,9 @@ static void damos_set_effective_quota(struct damo=
s_quota *quota,
> >
> >       if (!list_empty(&quota->goals)) {
> >               if (quota->goal_tuner =3D=3D DAMOS_QUOTA_GOAL_TUNER_CONSI=
ST)
> > -                     damos_goal_tune_esz_bp_consist(quota);
> > +                     damos_goal_tune_esz_bp_consist(c, s);
> >               else if (quota->goal_tuner =3D=3D DAMOS_QUOTA_GOAL_TUNER_=
TEMPORAL)
> > -                     damos_goal_tune_esz_bp_temporal(quota);
> > +                     damos_goal_tune_esz_bp_temporal(c, s);
> >               esz =3D quota->esz_bp / 10000;
> >       }
> >
> > @@ -2415,7 +2554,7 @@ static void damos_set_effective_quota(struct damo=
s_quota *quota,
> >               else
> >                       throughput =3D PAGE_SIZE * 1024;
> >               esz =3D min(throughput * quota->ms, esz);
> > -             esz =3D max(ctx->min_region_sz, esz);
> > +             esz =3D max(c->min_region_sz, esz);
>
> Above change is unnecessarily introduced.  Could we keep the old damon_ct=
x
> parameter name?
>
> [1] https://lore.kernel.org/20260426005341.B393EC2BCB0@smtp.kernel.org
>
>
> Thanks,
> SJ
>
> [...]

