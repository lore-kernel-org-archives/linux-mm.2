Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A78E606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fvaWGqtC
Received: by kanga.kvack.org (Postfix)
	id 5C9046B061B; Thu, 12 Nov 2026 18:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579F96B0620; Thu, 12 Nov 2026 18:28:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468896B0621; Thu, 12 Nov 2026 18:28:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1501F6B061B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:28:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29C53140E89
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:28:41 +0000 (UTC)
X-FDA: 85428058842.10.518DFF0
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3AFB3A000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:28:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fvaWGqtC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794526119;
	b=ZsdBysCyqXnc+MrV+u370lJLigqE+z4/CCgM9ilvJU3EhWsYn2ZsD4S0kTtHk6pdNWvr4P
	MPxtwtvSDHbKiFP5zzsRQrKLoiwFo+YeRQUXvnN7K57MjnQsH3UXKcGEi68ZxTxvfhhOf3
	gLUXu/imOMCf/4GoFBlhqKrSuu3HfMc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794526119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ud0iTzGbcDY9wbei2xzT/jJFcow+iBpBuCkj2PH8570=;
	b=vzs1aBfdNzSehOmyydKEqmY5TxshH3y6AAq2PV+VUyuiUmcXFxgRRh+FsrbidMBhQPRJGA
	Vuf7BJp5soGBw53BQBkSEyXr4ZAFXPDN/Vh/bg7IsW9KPuB9GGSmaiwLJMPvNQMCCLXQb9
	E+CBRjH2R1eSE69bE74dJNpnJ/DXENI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fvaWGqtC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e1d0e5dafso844793f8f.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:28:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794526118; cv=none;
        d=google.com; s=arc-20260327;
        b=TLsS3K6tWcyyAW+heRwJdZLCJleljy/ofP27iPgN+zcfPXkCqQW4Q2N2+mqqt3RpzX
         9L0C/P2IpVEUmhjx/er0GhNrOGy6/BKmDyl8jO7F6CpU30cdQQJr1DpOBmfHcnPS0HXa
         WTFLrJ+3LHyRn9xo3AQFIHOB45Y8mCBbXgyr9nJr+B4EZw3DlNDYLUBL8ebs2rXezErP
         CubP7r3QUCKkh/QA1yGdcttQbY+V/lR3fXm93Oq8u7PK//LV3d1AJzQ7GxCFfMYPRU/h
         Qf2T3XXwyilwwhxsOoQjqK0NUHkzKiY/PTGMoguyvdrHOfpCGmbDtgyEeZPJxHowWcXB
         /49g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ud0iTzGbcDY9wbei2xzT/jJFcow+iBpBuCkj2PH8570=;
        fh=PSOpJ/vlzy48C8dZ62UF4eyxmbmE98C9bgjDjKxyO6Y=;
        b=FxnA1bflJmOmBKoyjNzqn/GO7rscd1E8/DYxjwcb4za5h2fJvc2wfR/4PD1cnWnJgC
         nWOAr2clDBKDqq/IvI2b/gnb1AlG+w7kQa9fH3+6Uq3cJpkj+Cr5f4r4whMJTHLtOQfc
         y5eJQBvo360liE4NiZzKg7E73FyC5ru7MGmxVD+zb6y73z9sL2Z5bxoV7s0At/6d0u+c
         MbHsn1yDPOnzbLQGFqcZWcZY9g+1VbMX1Un69fA7tMlMzcagk39Qua1IXi0Y+ftN8hlR
         mzRjZrOdeJ/kzPeeKCN4F+giHmuXTBlnOgz61lS4A5jc9K+HB+u9/2yhBJg6jyormTN9
         vkUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794526118; x=1795130918; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ud0iTzGbcDY9wbei2xzT/jJFcow+iBpBuCkj2PH8570=;
        b=fvaWGqtC4CaCV1iMCnrxoLI5n++voySzj/9uI/Mz2ku4Eo2c/gVW881WCFzJPGwZlz
         PsomjUWIVPRDPYFw6i/OrY3VmUOwjDWOgwNb5DLA7bU/61qcvnGn+YZhMj4kxA+tF8Bq
         mWDDjH15LqmI7ipT0AcLAsoD/Wj4H7HqeK8UXIk54pY/ODVwfkNG4xSUQT4xGpVod7U4
         xuHjTcHeIpYnm9+YHSoy+YygFolxdy2iu12t4xpTldg8vHK7xmLOgB+6YAaOZ0MWqd5v
         5EgF4ai9tai8cImvS9pDIGaA4j6zg61AfIreos+nftLAIKQKTBWZ1y6fjPYPc6Km0fpq
         0qYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794526118; x=1795130918;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ud0iTzGbcDY9wbei2xzT/jJFcow+iBpBuCkj2PH8570=;
        b=abc1jVg9BUg9hwvyFrnf2vlKKz2Qlu7Vk/snAUTFHvrlWZoRpT8UE8L+QMtxR+EHCg
         Li889nqkjci1fcdhs3Qw8Z/rz/Oij7cpUWGB9oECholibeoBAH8WKm95KxeUD/otMCph
         h7JGL5PfqUf/VwpgkxfW98syJ9IAt7+M2ZafJIFjQTgHIFc0mArKJjiVKFYRLt4pIA/8
         vCoKQWeh0fexI/cAWq2rrIuyWq+BlvMu3qepQPw1tDhhzLXFgR/FLBk0JEQbTwgHQggW
         70v6I/pSYErwZLK9ECfcWkjlrY8cBIsfKjrUiEguwbQCg2ZGNEkhVj4c/E2oaowvEVDs
         yQKw==
X-Forwarded-Encrypted: i=1; AL+hErFiEHeA+33h9sv0OPouU8qoV7J6Qo52MxQdy9R4FOrVNEVMZYtwV2OODvdVr0Rm2TDaSNblnycH0w==@kvack.org
X-Gm-Message-State: APuU4Z8pQ+k0HcVl3833zgFuPcy+IcMW4fgoWK4iKxwxBKqoA1MqnYaA
	khf5HXHckMin1RY8RowK0GJq1731hGoswub9tnmhS+Lzzf9E8a1kHAnceP0BndoPL79MuivBg3y
	4YcoIs1/H9fnh7YauPiUTo7bOUqU6aXU=
X-Gm-Gg: AYBFou2xweaoXWis/+sRLv8Ls8J8LOx8UmQPqnT820IpsmFPBbOy7Hy/mBYmmRDVxqW
	tGUgEjFyvdjlbPP+t66nmLV1JjPnks1/zzK5sAFM3+AzemGN2EoFj8F21tUW4f7H/YevvYzZNf8
	Hq2HjRvq6NQmrC8S7gA68d4wzsELUl8ngvAg2VdQcrgRUh2oRrmsbb9yThlt8XKqAoXeJg58GCa
	QHln7YpA81tH+PD+9pmN+CJkKibsUwTnPLZxP6U7woMaa9uQcQgSlj6riCgswrKS+RxKn4TGHf0
	+/YCh3lSbL0G238c0D4eUiZB0ZcmfdxeDPMlG6F1VdrLRyLL5BDu9iwtZ3B2LHCngqHXA4cMMat
	qRxqgsxrgJM5oK1H3R5u8SrEyM0hR4VbL30qwSwZ74SffLFfUujXQ0vXUpf/LxnkJYKomA/WWip
	qCXBNRWs2jYK/bmMA7Hw==
X-Received: by 2002:a05:600c:8903:b0:4a2:1104:7ca7 with SMTP id
 5b1f17b1804b1-4bb4e2e9c80mr81556115e9.11.1794526117616; Thu, 12 Nov 2026
 15:28:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109220958.2071687-1-joannelkoong@gmail.com> <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
In-Reply-To: <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 12 Nov 2026 15:28:24 -0800
X-Gm-Features: AclHuK983X0zAcuE47Ia31MukS-99elwTA5JiS0-eX1cUgRTz0ztHFdzDLnLTso
Message-ID: <CAJnrk1aMwrEHdv9v=1cC54QpxzRGpRMbiu07KGfyEhzQNP4XFg@mail.gmail.com>
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>, SJ Park <sj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>, 
	azpijr@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3AFB3A000A
X-Rspamd-Server: rspam12
X-Stat-Signature: tqdm8bipezqzd63abwb1pxy4fs51htyc
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794526119-839967
X-HE-Meta: U2FsdGVkX19W+RLrlNWuEiFqVNUc/rO3dTzN2B9BAwZSO1TOcIbhrWXHE74zWUFM/+Dfk6JFoc81dnTJWYKWkCgTsva/ffv3Qi+KauZXCrNyWHXAoSZSQFMdkqBlncIthKlhHgYrtwjrWICmm4Vl17AB5GCm5Sy+js/WQYySLIEZl3NXrMZucuqdRBoL/4tVaF08ieDhPAdaxiEQGHr2PYlN/qaA4zAEjCQx0xugzkt1FV1wR2WuZdP89Na1QVpEaMwa+ZmO10HeO8LXq6AajMK5jww/E5yb/v6uVC2br2KFLPbePx/TTLwklTwMB7q7F428lO0CGKayUBJGqHamiLOjJse8k9rMRzQebdkQyh5EWBlT9SG/oJq145+5Nahvo1ub3X76P/2HA/1mN1oF77iwMAcPEbQiRhH6HYFnv8zRXvUnej3IpbJ0GO7kDTjk9DcEfIMlDS/2+ue0QSuQANPxQsaovQu7AuNZCwFvzmasSb6ouRP2UwWMfHUYexAZ6zFPWB88CyAHbEebteb2dsriMZVGEQ9NcB81FTgWb5CrxZ92mWWwHJSW7l0Gy5114o1RiGK9UXhE4FbwJ9QFrP1k4/6TIHjJss1AhqCm7USTZ4mQwzsJZpWGqq+qpyMMP4ynFBcb8vPjBLqLRgDOYExSFwV8efIjdnQxAGKjTLsuTFwckxqpo8q8G+gInYLz0wEGhpOnkK8483v8JW3iOjKJTJK29RKUWEAleAXIou0NzYpT6uJcFBTDHWypriC5pNdFRQaliQmr3o3AhGcLfD6btLqBDvF5Smrz1ZPBxmYLrTES0s/r2z1wwYg2AzLvzg3VzHPQvhPCcucMZ192fO/BQWbeZq2E0ZVvDUX/D1a52lFReFnKoCTcwPleTpXOyHgBz7LeGGwxCT26nC5JAQGNQgBT+TZBavYjGmYJ+ARLZD4lE2pXXcV0id327KRyY2JdtGgUtZgfKn5T+pn
 ZDjS0Ggr
 8wLlHiOJGxAKPAcNodUKa50eJ43OiPe2KsjR2QCanP+iqYVXJPnnLziBQmk5rhcO3HXWbh49btVVUt72GambkhHvQI5MFjwnqM6sMfTc4s0jLZoja84ExeJj+Ora2gkIlfuVjbb8kum5VD7p+OPhnR+rBquFObjv5SCQLj5TUcEyD/odaOAwpR00oI/MpS9OjNVwXLL5Gjb3tQyKOlgE2IA4Iz9lwJK79MNJKw+148r9Bgkco3N1XglDvq9wXFT3mhRo0eJ01R5SFmKd6IW0YiH2wJIvvaWw7gypGKi/M4PH+k/AsJploiKn2kzGlV0dBZSC/+uzQKWQERlRtuePnlvrPyIuvYj1zF/bECE9NpuEBWIU9iKzaevBzRivlaZ42qJcLoip5IeLCBWKMzSfkZ7F1hLuhnWNYa4Ig3qgWwQx2PPlq5pwDtr+cqvZ25cFMM/JrktcCr6Zk+jzJQMxbZaIo3weQHCogjUnxqsTP4KTfCnDGhGurKcF23Fmwidi/spcgue86WUdkB+Zr2hinirTy2u2Lx9EFa5LrmbnM4jC9qg04fr6SdlrAUFmcj+xtgmEP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 3:49=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> Batching resolves the problem in the common case. For the remaining parts=
, we
> should likely just check in the deferred split handler whether actually
> partially mapped to then clear the flag if not.

As I understand it, there's no simple way to check if a folio is
partially mapped or not under CONFIG_NO_PAGE_MAPCOUNT without doing a
rmap walk. Would it make sense to do something simpler here instead
where we just check the folio's partially mapped flag and cache that
before we replace the PTEs with migration entries, and then for those
edge cases that the batching solution doesn't cover, just restore that
flag back to its original state?

I think this would add coverage for the migration and reclaim paths,
instead of just the deferred split shrinker, but would miss the race
where someone tries to do a partial unmap while the folio has the
migration PTEs, but I think this is already a race that exists in the
batching case. imo it seems acceptable though given that the race is
pretty rare and doesn't have any adverse effects except delaying
freeing the unmapped pages until the whole folio gets unmapped.

Do you think something like this makes sense, or would you prefer
having the check in the deferred split handler?

Thanks,
Joanne

