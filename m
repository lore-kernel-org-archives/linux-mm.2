Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12428C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269466B0088; Mon, 21 Sep 2026 12:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A346B00C7; Mon, 21 Sep 2026 12:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D636B00C8; Mon, 21 Sep 2026 12:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD7346B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:54:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A723120226
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:54:29 +0000 (UTC)
X-FDA: 85238367858.24.4836541
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	by imf05.hostedemail.com (Postfix) with ESMTP id 522EC100009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:54:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of clx814727823@gmail.com designates 74.125.229.205 as permitted sender) smtp.mailfrom=clx814727823@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790009667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hK+61oik5gsxN96IHn3CnokMCdTIaajwpmg47B7x+JA=;
	b=HujP18ym2R5SQwDSL40eHiZdnehmugmH2OXWPu5OZ9URggWy8NhBmhZbfamuVtzD/v6YWc
	uDl8fM5COyxmIWMRqyk9Jj8KUZUBEqWFM7AN4D1z2IRVfzlzq4fslqHGq65Xt5HYOIvQxs
	KpnAJl7Y+UQj96HCCAdXoUefm9GkVMg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of clx814727823@gmail.com designates 74.125.229.205 as permitted sender) smtp.mailfrom=clx814727823@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790009667;
	b=DsAjSRYKj8pW8o5UKjxY2HKpZOgxbWVRjb7i3Icl5F/KTWLsdIlod4xCjO+dvCPn3p2vc6
	BrAHdy6jpdwj221j+VFWiHLBRkcbjhf+1bGUWlAWYTp9HQy1kYfjFUvjNIHf0bIVY3KQv7
	BFBA0lb2C32GCRUgfe69nA6Kc7Y9r0o=
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f16f15so3404720e87.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790009666; x=1790614466;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hK+61oik5gsxN96IHn3CnokMCdTIaajwpmg47B7x+JA=;
        b=c8jLG0qOIIgga6FqjqfYydOu//PGwlVXUAzcOS4VirjeY9H/D6P3R/VwIqeEfKG5BW
         ZfuCsUDCLTAYkLlGPo//Ulk10ZmPhVYW7qIFYLngobdSxkpdOqWXbEnizyUKzK5YSPu+
         o1xOQhu9e7Sth2LSHLSqN7iwrK9Hni+FSOPTiuEDLrGwKjJDLJPIM3CWUY2nqkcUaEyr
         sJznGlFrYZlCUy/x6luW7JFhNi6eTlW7IaoeYIn5528IMTAv0jUs8evN455K0JHJnaAq
         IOj2ovrtpqEh2ZEpD5JZAURnB3JAieCENlhNoj7xrZLWOyefv2CxiRdxdt+GGzArq5i5
         iipQ==
X-Forwarded-Encrypted: i=1; AKwUvByGcGTAGo1CHz/dfzvM3gmUoJC0TipPzU5M3yuymiq1Qm5/6nReATiwZiy6YyjPSLoZEz5/zzztpg==@kvack.org
X-Gm-Message-State: AFuF++khMxcmbTtQhQm917q4bfdGOBwKLo9APpIIfHU7+8XyGRNAjldQ
	0F0bOpfuE1nopW8YInTqfWP7FQRfSmutEVan7TsbhOF0Oe6nooyQ3BDkkr4Rf9Y/AX0p6A==
X-Gm-Gg: AYBFou2VeWdssQJkSPiQTPHOg1/Pbm9vtt9l7yEtXjplD8/ttv2TsKChUD4vfb/zPN1
	hBnjAK/rWgKkng8AaLAnmtC/PtA4Ha2hcb1efAD60kMCE7f6/So/qkD2gg4yBuAjV59Sm+GQh6i
	+7zt7s4ps6A7DpFB7DXTzfAHgllrnXdu+6NL5m4n/a4tS9huNS3n7xj2ZsdwxQfqUj6ZXwDv4Th
	kpKFP1GKSnOLHKQPZALIA71x5y1V6IDaWSWfXwA3h4UJ2AwrcBJpyGehOfdywgkJrdZs9N0TMrX
	GBqH+EFyhQLzZDJvf+dOw0CqiB/G57UE6Y7cFGIUpxfDmdy8Y+tBZJ7qhyRrKHOBCGiwf+2P46Y
	1vhgNcmE5BL/FE5QZ6WG32OfqmY87nLok7Qw0e5JkmATHBUiIJ4wrN5KquhTUGRAFr//5+JfiFY
	Cu2zCia5EMQrL9Q4gtMNU0iD0q1pyBqD7RdgVg1l3TJYOgU0MHjBoDfLlumccorPf2VfcXhsPoi
	2pS05go4U1Pp0ixHJz246rpRF4zn9ycWMIaYffr8FO6XbjhwmTWjG84McKYW5zZ
X-Received: by 2002:a05:651c:1543:b0:3a5:df43:7628 with SMTP id 38308e7fff4ca-3a5fbc23d3dmr23410711fa.0.1790009665155;
        Mon, 21 Sep 2026 09:54:25 -0700 (PDT)
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com. [74.125.229.205])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a60757ea90sm25809101fa.11.2026.09.21.09.54.24
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 09:54:24 -0700 (PDT)
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f16f15so3404664e87.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:54:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzIiMiy1NDO+2ApMBCYXQMtD+RrWL1S9bIsjYG7LAcgYhKm1fZp0kAo6sQ4MsO46IruR0yMGWSulA==@kvack.org
X-Received: by 2002:ac2:4c4e:0:b0:5ad:55f6:1ec3 with SMTP id
 2adb3069b0e04-5b8c181f45bmr3718755e87.5.1790009663874; Mon, 21 Sep 2026
 09:54:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <lhuecf9cbl8.fsf@oldenburg.str.redhat.com> <CAC1kPDPu41RxMLHpPtz4VqfkEZeu-fYXG76XVZMh8bbQa3okaw@mail.gmail.com>
In-Reply-To: <CAC1kPDPu41RxMLHpPtz4VqfkEZeu-fYXG76XVZMh8bbQa3okaw@mail.gmail.com>
From: Chen Linxuan <me@black-desk.cn>
Date: Tue, 22 Sep 2026 00:54:11 +0800
X-Gmail-Original-Message-ID: <CAC1kPDMCFoVsPDZgoCF6mHqHQafCkDc3Pohpp6pNOLJzE2OTYg@mail.gmail.com>
X-Gm-Features: AcwNN1U1zJ5xAFsdo7eYagPVPgcyEU2aovVJcIoR_uPclCIazBY4PYSmw97k5Co
Message-ID: <CAC1kPDMCFoVsPDZgoCF6mHqHQafCkDc3Pohpp6pNOLJzE2OTYg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Chen Linxuan <me@black-desk.cn>, Jann Horn <jannh@google.com>
Cc: Florian Weimer <fweimer@redhat.com>, 
	Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 522EC100009
X-Stat-Signature: xw79ed57734iuhks6shy9zedmo33j4w6
X-Rspam-User: 
X-HE-Tag: 1790009667-96807
X-HE-Meta: U2FsdGVkX1+KP6/9udAH9BweUTTfRUFnfju2Wzt5j0JqFwWH1LC1aLDTOmFPeQU8SnoeCzGtoeOv1ZNGRqtVgj5B2qOKm3YyZwSQf/ulCQOVu01Di2ezFI9i6s8eS5Y3FUSKWQKqBgeOm6+hFKkWboqwCgmQQl6A1HuYnZfCgTRulzum8kPVsc+JD+PY7WY4DelLcuQCS9BjzOylKKmQ0GQVwjgc2HKnumGNQw0Az+AXbW6iw5sJgUp3+nkKMXS8viTmL+28DGkdTsCVSPyrioiVsjpVH8PalmXRLwpmu5lkbkCV7JOWLU3c1az1OFCTksjXPCu4tgMDmQKwQcfw/DfEBb30IvEOW1Qgw2rBpcvNaJDjFi+/cDI9i0QFvB9du1vKPDpPVv2RKpl8bgadUMrROge/LqT5y53iHQxlJmAChg1ViQgqdEKYeyuhPgCHg95BkTcgfnox2Gi4tA6HS0au4i301OM1VMVJQFNhZY/Ig+rLj3PsPZme9atsdQ8xKVXPXNyLXLodp6sNXMDqNU+xSjQ/ymNuEBz8D552hB9eBfzNYgMHlnoPpnEW7zx8rzO2fIjUZSFzFzlySbPveYGcl/dgquv6q50n7LXc+eMZs/f0J+gL3EgDTMyQX8m4g5qa5d4y6cm0yY6vXDPsLcNRBqtcdESRd2u6pMoewair6rWbrv9rjkghy47fBdEXUs9UPZHccx4x2nQVtm4vrfDU4MNGHQYFP0U/mKls2NN+SW7zUzn4akR+P4g2Pfi2xQ5PRhShIMjxN6107fI1YGbI1h/PEEjqUtgSclLbA2SP/Alj8tgn7jCGuvfe2v16RWd5Tr7KL91599bkdMT0BisIU/yqC6rf1/OcbvPpO2sFeFBQDuyKo5HTJ9hg0UODJUCflMHHPg9VoJH8IlG0sBUDfBXX9gX4kzFrsNmANAJf7ZfPjnOPkWa5MGIXA+B3/NyGP6awCtMTH3ZkMq3
 38AJ/4S9
 k0OpU5U2UqLDXoqs1miY423Xk+PSnMQpNV0j67slUaAa/6jxr2/vLs3TLJQKQ/PsaoeUbvImuU04V9e/wtva5mHm/41Ie7Kd5jLh41yzJ24RPt8824okj1PsDHtgnOuWAjxcQrvI/3ii1SVQInKfsQGLIQoDS26YKwCV+FmCCpsftwuRZJKtFC+I/5UwthRqCJEtPc+JObhv11VOd+L8XbyalSTe5C3VSBslAA0tjZnMr4Sal1ERsBLvVvwd0YKeDuTPwPh+D2HVCkJhZN7lo8qXU1G1L5OZdSsUhTRAkdk1NBKB4x0YA+rfFw0lhtKa/6kvmKlpqZwZPylRIsyirQB5GBwZN05A/7+DzwHq+uyCf55B03z8knEHtnzVw7JosugxDVtABsz1dnLt6k0BFN5xfUSkV/4hD9lXZyPriyuUUM0MFCcgFBIxvuIXFLco6EPiZT/vVbaAvIQ3im3WDJOOGLaqorpF3cSIw2MXv0aO3PE7uOIpXZnVUicAbxDio9K73ptMwLmBmIis/O3ZHPacJm88lPiaAjgNOpNoVEdVkhEY8a9GbheUuWfyu2d7cNzrF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jann,

Christian suggested adding you to the discussion on this series.
I sent a follow-up reply with you, but I=E2=80=99m not sure whether it
reached you.

When you have a chance, could you please take a look at the thread and
let me know if you have any concerns?

Thanks,
Chen Linxuan

