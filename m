Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D25606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 21:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k0n/Oo0m
Received: by kanga.kvack.org (Postfix)
	id ECA926B05B2; Mon, 23 Nov 2026 16:23:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55016B05B3; Mon, 23 Nov 2026 16:23:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BF06B05B4; Mon, 23 Nov 2026 16:23:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADC7A6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:23:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D41CC082F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:23:49 +0000 (UTC)
X-FDA: 85467660978.24.CB82DEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 553D2C0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:23:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k0n/Oo0m";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795469027;
	b=5D8PTyIo9x4TXU7OKUg6svZ1qHTP/4NwtwB1l5kB/DRJpIhX5tFWYQD8AF2noS4XmgBi14
	c8dHfiLrE1bY3Fvg9y84ZdyfPsTlw05UPZK22+O1r/Vu9nUgkstPECN1ZVnr8IpK97aC6Q
	iQsPvdLn+ha9rtRcJhfsFWZezucre5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795469027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVAt2we2ngEUNATOIEmS0h16G43bUM0UOuNkbG4NCZQ=;
	b=2+8gGcbQKGoV9sl2OiDSuLgXbssXMAPEoz4tqrf+2VUQqz1qSsLa88e/iAbsmup7WvQeSW
	WI272r1gJODazisZ5oKl/iM1QUxypNBM70CHogLcmquHsMOPFaRxgwJ+6dEuPhiSvzWp5t
	dwcA/9j5IjD4tmwySi6khI9oZNq8/iI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k0n/Oo0m";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E446B61847
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB021F000EB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469026;
	bh=DVAt2we2ngEUNATOIEmS0h16G43bUM0UOuNkbG4NCZQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=k0n/Oo0m66vECJjujn/GknnMZ+yIIg+csYryLX+vjqodMeLUfYzEAAZVFOrB5LhCq
	 ksAyGgAq2ydka1hTH6kri5qjX3qU6Hzpv+u4hbjhUqURQfXlA+fqB54x8+uGiYRzfg
	 ANqQG7OxiNz13w9yTnpKcyTpQNxpLUJBpfAH2T2nGgFro8mq7n2EivgDG5Z+sitYd8
	 zTc/4Hsf7pQdbSkY5Zq6i5wL0oLlNpU58bn1DM72IrNSYBJcQVY+EU2/jXtwg3oe60
	 HJFrsVnltNeV/uzg5jxR01IowHNqZzFoDneQvAjUxnX9j09UXDTvRPOGilQacp7roc
	 LjAR8mT8N9n1Q==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-949b0d32315so326307085a.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:23:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGEwbMgtc3gXF4sYT0PVQ0sX2LCmUq9ZaTSxCy5zKfmS3uUJvOZna0o8T+7O1XpEqNkC93HYd9V1g==@kvack.org
X-Gm-Message-State: APuU4Z9stttMHrbtyGkKdlP91Yhne+cypklchEfdi08Dl3HGoWRhoLUa
	sI0an3GE/cL7AEzOcifaHAchbFCAdGAEgKofO5aVttJ5Oi4os/CLjAqp1fvnW542rR5W9xt1r9k
	5/SALmE7diD8+o3IIl7S87+1G//v/7Io=
X-Received: by 2002:a05:620a:1b9c:b0:93f:643f:4f4f with SMTP id
 af79cd13be357-949ba9ce6b9mr1992217985a.50.1795469025645; Mon, 23 Nov 2026
 13:23:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261123135200.4086519-1-max.kellermann@ionos.com> <20261123135200.4086519-5-max.kellermann@ionos.com>
In-Reply-To: <20261123135200.4086519-5-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 24 Nov 2026 05:23:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z8RPpAmASUdS3hw3DWC+6VtYQ0yKVDamtYkM4dND5SPw@mail.gmail.com>
X-Gm-Features: Aa3M54qcTL8SSAjAQ_RVHmHSBfar4B1hbLxQu69vEWbG1NZwuWI1C1D-CZ5boWY
Message-ID: <CAGsJ_4z8RPpAmASUdS3hw3DWC+6VtYQ0yKVDamtYkM4dND5SPw@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] mm/mglru: avoid redundant rotations of young memcgs
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fscupxd45c4hythw7wn19czpukrgh1kz
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 553D2C0003
X-HE-Tag: 1795469027-506400
X-HE-Meta: U2FsdGVkX19/2gWvg1GSs3Nv/VtIoHoxolOTFD5QT/t2B9PM0R6K4z/dDlBZ5qmwf+yXHoEm0o+LFW0VQ0oxh3hVokS5nUzdY4VRFxbxiigQUPMMhTujuq1SyALtOx28jWlrEqh1r+c02s2fl1Ca2YZMjFCzkyZ4AfY35xpLNZ1dLKXoCYWdVhmLpfYgyT5wfIGedicSq3OfHUM2F3MQZ3SR1qwSd6PveDK+1aEpCm91p/Ye+8lccwaIMmeLDO/lgC3fgHiqCP9Yk6X02eYal9hHWoNvqpm0UcpivwniKoC7BQj8IsPWLDBRBGRv6UlNz77DtSBXX7YUV2AYv3CxSbVWM1UhGzfXuz9oSUNO/y005UxJhf9IJJxpQvFCeNkYz+CQJDlpYgNp24lY+9+1oOKBEDKKkpf5XFpHRESFQvBNfYb1LEJABZNehXZKjspoT162OMRd4N1VUl31VWX3j5PWpulFWFjkoO1Je+Xvjl2VTMABogUsnEwQZIdRUf6TEoW0sD1lpwrQEFPiI6uyBiHzDl/sJ/OjO4Mq8RYvBJXHg++GGiM1ce2JZ5OPeO2VPDM6oePXjZhdqvTD+7dRfiZwUMbbZmWWwPIpPuEnFu2ljdkyHosreny//kM4hYgH+DKABKgtylvSaPO375tILpDFi12PUxwyHzWA3V6NggCZf7X5X0PCOBavg7jLtH8OR7vCaKw/dp2C3ky0wgW8V+NKQr1dtF1sJVdhPlqja9XMo8XsoRBT7jLXAsdiB0Cl/slCJ/3zREQRMUXQUEFSqnw5zQ0bnLm6w4Z4j/UUjWH7cN67fy+yIU7Hp/x1xr67XxJjo4ps0MDoPDIOpXdM+hMGOYHNFHiJr9hAc9e8j8LhmFYf1oVbfUs8v8TOZAHQLKYZfQxb2UUpEGSNQqgFyLYNXALp+Uk+G4xqjrgZ+23jS3hpaSVvSIFyU+IZ0QM18FGajYZlDqifxOlEf0R
 OTSO3PIy
 0J6sCqlrAwr8Nw05q44WBBpfFoslf1St7rabOCNGHOQsJXQpzlxZeAECs9oC3Uua/jlwQ6Bw/hfybDRkwwifbBYCzl8d2KFl8poOxyl3cTKjpfqNNC8vJfXqdjJH9X395ZDSreUGtkHK4WtYY1skjUKeY1y0ITMjSLzRap2B9xQKb8miM2SgaFkH/sxULoHLOrMacs8XiGNef1P39fI6KNNH9TGTMyJdCYQYOrXGRwX+svOFkVlJ344GcgO4skvt/4MIjCgwfyLY9fXo2q2rt2f4eepkaAMwGTeKcs3Qa69H/h4T8oOupT/APPzWKsHToaz+DmA5dUEhVrf4odlmdDOzfxlaTIJlkZ7cREKWCmyvTJofV7/AX7SspQ+302akT3TUXEazagqsaXa9kDe7IoU44Aw3z8lp30hn+s25hsLpdWDQAb62mrvddzGtVgAB2y36AicGjQngsZgUv6EpwHf4dAmw6WjB6woMaxRMF0p7/y2VC430+brY3Coi00wZeFJyD+Iv4WG10qtmesm/a2YXFFcNVsjqnNOi2TTyNts9v2EtKPjbxRHYI/h8HxTXy/sKSVSNfk/FIy8N1Y8DZn/VeQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 9:52=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> Concurrent reclaimers can request promotion after another reclaimer
> has already moved a memcg into the young generation.  Requeueing it
> into a random bin again adds list mutations without advancing the
> old-generation scan.
>
> Therefore, skip `MEMCG_LRU_YOUNG` when the memcg is already in the
> default segment of the current young generation.
>
> In my micro benchmark, this increases the request rate by 36% and
> reduces the average duration of each write request by 27%.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

