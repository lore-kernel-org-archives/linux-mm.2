Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5D4606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WOz9ef/4
Received: by kanga.kvack.org (Postfix)
	id DE4416B00EF; Tue,  3 Nov 2026 17:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94866B05B6; Tue,  3 Nov 2026 17:37:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84406B05B7; Tue,  3 Nov 2026 17:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E66B6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:37:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F9011605A8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:37:04 +0000 (UTC)
X-FDA: 85395269568.27.43F82E0
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id A8E071C0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:37:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="WOz9ef/4";
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793745422;
	b=j/pfrjHIFLyRwsjZM/UA7EnwNHXcflw/55X4rR3agqMuGvBysEhjFdFRwDOQVuIWLFyG5/
	5PaqKN8J9ibUYPHgIiezH+kNCEGeB1P5/oZno4fDoCIHYj+11cDDmwi4bKRcwWminhjru+
	mYxoW7SHzZfBwRXd/J46h86DADjF/UI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="WOz9ef/4";
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793745422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVC6zXtmTlj5EAbSSjNHwPP18DR41YQR4sifDw97zsg=;
	b=TXJjZGQRoVfBflu7l6Akj+1sArCOgxqi9ZIOcOlrJyeWc3BWtnZceTkYYR2sLebHJG5O1m
	y6hH+enjFmnsr2r9SSK+GaQ20u2CM/5TTOWg9j28J4MqVqPLT9Ij/Ke9q/pCZgUEQz6PUw
	nLSgeTG3CRksWlPlF3g+rIAMj7V0Wfw=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48dfdd0678dso63449f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 14:37:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793745421; cv=none;
        d=google.com; s=arc-20260327;
        b=XflR3JJZ2lSlW6MCcvX1xWGeGCj+M1IxzTmmPR1OevBCzkvCdp0+03PVAjSlFD1seG
         AVa/cWT3IQrKofm9DWScQfcTn09OmMNJKPiO00gRNR4Wrdc4/vPQvFDy0m0574HIFpiG
         pY/ZHfdAsEbwhZ+XBGdghosH6Pp4zxG6N6oOf4KS1ZokK0B4NCW3HRcuNDLy/eu/JCZO
         NnSlrs6zHG9Lkx926ubHtTjyFBPUvW3NZ61nfqlulKYMoPzbsJYE6kSXp8RVzukAWPzT
         5ScUvZVVInBTODtX276585iI6BoYg72h1LhrCI0/lQiAz+TBNYH7HUBfDuoqJlIDYpIg
         VO7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QVC6zXtmTlj5EAbSSjNHwPP18DR41YQR4sifDw97zsg=;
        fh=fNivjEQRIy9LQ0D7OQOyFIxS/nJ9H6M7lse9dZcz4mo=;
        b=QnKlSvTmxgldf6O2f6urq1JbxZB7kktrXje8NE8GgTnEF80bGnUaJGYigFU9xlMXiW
         CPlsDd++Uz46tp/ABASInxQ+/Ec3WUYFYurYpzTzKtFIIOTXCfnxAAPS10cggd+baq0d
         VczQzbghZ+5QxPbodjlXOgB1DK/K1+18Xw0Ai+vr1+GS/TbTI45CFm6WfIyQ2PfqCzxN
         9xEddxENXXGAOEjxdjJxlZYqpNQvlPCECLs+aLNRs6F7u8fXetRIfDiJEyzg9wMQJE39
         SSrC2ZhczyloCH4lkPbmxBhuMIm1rdfJH5RIGgp9U7qOZMIanO75jLN0awBF0q2OCdNt
         rmYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793745421; x=1794350221; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QVC6zXtmTlj5EAbSSjNHwPP18DR41YQR4sifDw97zsg=;
        b=WOz9ef/4DM75DAkiaAbMl7f1+eIXZU4RkOHlm26z05LAFLmfo5iwTW3PRMocwjufbs
         EDAA/zEftZtk/dkE/3iXIElhXjkhVCfEOBpNPkyNwCnjyJjty6MR5t8aHFlefR0aCrGK
         q19C//uQVG2Sa6ViPhmVwczKKHwydH/vovekErbFr+s2vXbXhjQ2L0ZWh3Qhd6cEEO1O
         8+Z+VVkLhca6UoCj+gEBOS+062XTNzHg0uKTJNlvPCs+34G4ATNSJRGH7VrCJdnzU+9n
         IZUGE7U5wokxYuSJNpBZHIA1A1LQSfQtBa4PQr6vnxE105CT0X7Iy6ZIiGnYwaiFX4IO
         CwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745421; x=1794350221;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QVC6zXtmTlj5EAbSSjNHwPP18DR41YQR4sifDw97zsg=;
        b=OzOKalcNJZ4+Z9wOm2WxbNFU5DfRYSMXkXhlk/ZrXm9IOPQ40C94dPtfOxYanWwPpR
         oxA//+VrAGheMS3EukTJPkaZ1yq07Zm79lzbba4zgEFGehuBa9NS7oajdds906DWzplo
         QguTo6sknKKZ1XziLnxcoDMtWkhAV2nPdNiARLT41iO/YEanenx2AiIkpclMwY10o7BP
         tCecG0dCoDdbDBn1ZAamOtuHEGUU54Udllr1FF5PcphDQSCYI9iVJdju8K1qCDz5MlHX
         ZL6cwS5L4AaWRXt9rpKwjjioe2De1EVusc6Pn6rCyrDGk574U5B1+nzUcmpCBQiF5bKw
         l51g==
X-Forwarded-Encrypted: i=1; AKwUvByElweWAVJbv+62LMQA6206faiwWh+PYIeJmAPe0bktLOq40v382Dbk3ZPceQj64cTq/+Wu4Jz6OA==@kvack.org
X-Gm-Message-State: APuU4Z/HBCDGHJeL5svxuVjy7L82aaD8cs76oXRxUmt34fsgrcJxZjGw
	/fgcGQaUqUYFxk2hjo7tfDyNxPCDP5WRr/aTXxO9u8WKqZmgh+YTprlIE2NIW7E0TKjysg/Ddrq
	5g4suFJ+ee9QlFIIFWeig49xFYaiWr2A=
X-Gm-Gg: AYBFou2gKgt0kCJ3+j1hPysZUQ/brT5JohPTTeGp2v8aegHBIE/XU51FK6WbocAELCR
	0W4E1m6H8A3gwW24JR9meuO+gn3Gwn5tXqxEKW1vkC9O70Ov+rxPuVcoYlJLXxeFLhYQVq7RpUz
	TOWhYV3hLJrMI2k4v9Y5TZd0UbH4Q8iAFVwANRwF9Xsc9xN84yj8AaVi88ogfdDfYvuZnafR6BU
	UP56/vc4RWNCcwAPOjeSv5X/VS6MaID3im7CQNRaO3gaZzVEHlyGsj2zgL2dkOT5uxKaXdH7q2W
	qaM74O1d3Eb6GZnKisNs+Re1QAbx6wyA+jLjG78yUODx9JnjLWBqyU8+yQlHVhuE/OE7Zjc/U0T
	bHk2MbwapTXm0jGzszRFkWygvVJOTAz28xH01YWqRxQjfwPwMspJxGRL5p21VU+pwExTeYveqft
	Gs/iNIpGRqzM+pJDT0JA==
X-Received: by 2002:a05:6000:4027:b0:48d:f3ee:7cc with SMTP id
 ffacd0b85a97d-48e6e4f4cc8mr30979021f8f.30.1793745420854; Tue, 03 Nov 2026
 14:37:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
 <20261102225030.2743129-3-joannelkoong@gmail.com> <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
 <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
 <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
 <CAJnrk1ZAz2ro0-8CC7n8mEjpuRQ64=v0rABtygaw5e2Aohq3=w@mail.gmail.com> <CAO9r8zOa52hMRTXFQVnSWJPmijm+D-97AeZDH-MMK_-rGiSwMA@mail.gmail.com>
In-Reply-To: <CAO9r8zOa52hMRTXFQVnSWJPmijm+D-97AeZDH-MMK_-rGiSwMA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 3 Nov 2026 14:36:47 -0800
X-Gm-Features: AclHuK-AYBaNZSpJUjEtODEKJtvEXTubSyokZTs8vMfIpK79wH5577sQO81jRN4
Message-ID: <CAJnrk1ZZdkrz+WSOFTCmCh0dwTLXcoCOOuufrh2JZMXqGw=Xtw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8E071C0006
X-Stat-Signature: xesxfbb63jsde6a7wunznmx3ge14hwfw
X-Rspam-User: 
X-HE-Tag: 1793745422-973405
X-HE-Meta: U2FsdGVkX18qC+XqxjHIy4qxROUW2WfUifQOMa5KCsFVfXkjgExsOMxO1On6JgUKNv3aiFFVBFNJWAxPs1MZVPXhgLkb9AzKMeWJakj44jgwVLI7eY28CWssLAjYbvhR5RdEO0o1LFIHK0GoNUYfhi5gwVQTi2Uj8TSBGFwS2aol0HhodYouqaLBnIIz/GXL5Nc4imdxUhweN+cpDQtg5VhDqM8HhdEaSLhcRl7b6FjWaCgsybHoS+l4oNOEh41KJZam5DQ9QNUBNLPZs1sCwHT1rwhQqlFTtp2ChaMDe2J4RH91jKh05maab+CyeosKYFgtWp72zS6+FpmwVzwbQDMXVuaawI7C8BlYrT4BGTUzzeQhuLAO4vznquWIzGSWaQrJb/aIZfrnAJE2tQTyA1rpB9Fl3QFWS+n4IjC/WWJZ1GfWl5/1uYO6YjpE+P+oZntvp6gyNKXTqtG+u8UT/YCJ+FgKxIuSD9FVOKHKUUIDNjItLcv7tsZoQQeybarLpjskHmOQd2HwXsKLr27ibMa9W/KlthHnBNZsUsSFMScPpAq/X3Oe0BpYbRyAEZRhzH1lQHA3232nc5R0LgqWeAcynObEcW6bgzWroX5OoZfLrLpHhAQoQ09LHzBp3DRRniVo1EEqGCVDt+cbEL8+9eySbI7qALXPpWVxHa9fLVodiV1rMlRIEJxrxaJsdaiJdbYtwa8cmOCmU8u7ybq0azFzAlBxWcXc+xA3cvbPQ/A4m8GKF9Tjsc+yvn4pHaFaw2/qbDLpUZOkb81JWciIV6kQD8sOKT8qVWkyrLOw/D1PpqrB1oZI6IU+isfokSVnmysZWrKQpMaYYg+B5UPA00nlr+ksqWdpSu7xqIJg6rczlU4jhKUDL3vbnwG/jH6uhVrQkNbDRtBa5fKPEgrNwrxBmN0mQRGdkBD3+Sb6SRkQdbbWS62pkRIMyNSOoSNdU1Pcl21/2+UNo8kAgN/
 QhyQ8HWs
 GgbQqjeiOGTIawE7I1+Zhbpq4T1ypsNB7oojCWWGowV0HJt/FSOYFF4UJnHINWogRIuwDCeiWkAilcylG5ys5ljETBLnrfMSlU5dqO25GMXO+lPFZQ4UnKm3h3ZtCFDEx1ZBrkfvybaA4f/5hUIPDYcQKpyRqVAV6JEz+Ve0ETkvqaKmD3WmD0Z41MFuen5w6MLZnT7tsGzZuvzHDzGqsyS8wMnRlcqu7xMi3ZP6iyMxwUF1xw0mE8oHifGvzI39m4RGwUDtGxaUvahdQ/6hkk2sDvc/d05AnAIUWcNiDCxZsuNPamHoLD+pMXyJoUCDx/nz8clxeG+Aqv1WD3zbcEWjmICyKEVhVBPi+bIZI8dcwwSEFjGAkLiMDuIL/CJPuxoe6HNNnVLdq+sIfqs3N7kg/EEXVRkGRuDqYH56E+7JloPpTBFu9hCxI18NF3rOVGG2HcJ/pPh5kM6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 11:33=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Nov 3, 2026 at 11:28=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Mon, Nov 2, 2026 at 5:00=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > On Mon, Nov 2, 2026 at 4:34=E2=80=AFPM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > > >
> > > > On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > > >
> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > index ac6c43ea8c5a..938843346571 100644
> > > > > > --- a/mm/memcontrol.c
> > > > > > +++ b/mm/memcontrol.c
> > > > > > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(cons=
t struct lruvec *lruvec,
> > > > > >         return x;
> > > > > >  }
> > > > > >
> > > > > > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > > > > > +{
> > > > > > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lru=
vec_memcg(lruvec));
> > > > > > +}
> > > > > > +
> > > > > > +/**
> > > > > > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > > > > > + * @lruvec: the LRU vector to read from
> > > > > > + * @idx: the node_stat_item to read
> > > > > > + *
> > > > > > + * Like lruvec_page_state(), but for the root memcg the node c=
ounter is read
> > > > > > + * instead. For stats that only track memory charged to a memc=
g (LRU sizes,
> > > > > > + * workingset, rotation and reclaim writeback counts), the roo=
t memcg's
> > > > > > + * hierarchical value equals the node counter. The root memcg =
can just read the
> > > > > > + * node counter directly instead of going through rstat, which=
 requires
> > > > > > + * flushing. Flushing the root memcg flushes every cgroup in t=
he system.
> > > > > > + *
> > > > > > + * Use lruvec_page_state() for other stats (eg slab).
> > > > > > + */
> > > > > > +unsigned long lruvec_lru_page_state(const struct lruvec *lruve=
c,
> > > > > > +                                   enum node_stat_item idx)
> > > > > > +{
> > > > > > +       if (lruvec_is_root(lruvec))
> > > > > > +               return node_page_state(lruvec_pgdat(lruvec), id=
x);
> > > > > > +
> > > > > > +       return lruvec_page_state(lruvec, idx);
> > > > > > +}
> > > > > > +
> > > > > > +/**
> > > > > > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() f=
or delta sampling
> > > > > > + * @lruvec: the LRU vector to read from
> > > > > > + * @idx: the node_stat_item to read
> > > > > > + *
> > > > > > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state=
().
> > > > > > + */
> > > > > > +unsigned long lruvec_lru_page_state_monotonic(const struct lru=
vec *lruvec,
> > > > > > +                                             enum node_stat_it=
em idx)
> > > > > > +{
> > > > > > +       if (lruvec_is_root(lruvec))
> > > > > > +               return node_page_state_monotonic(lruvec_pgdat(l=
ruvec), idx);
> > > > > > +
> > > > > > +       return lruvec_page_state_monotonic(lruvec, idx);
> > > > > > +}
> > > > >
> > > > > Why not do this directly in lruvec_page_state() and
> > > > > lruvec_page_state_monotonic()? They already fallback to node stat=
s if
> > > > > memcg is disabled, why not do the same for the root? Are there ca=
ses
> > > > > where the node stats are not the right thing to do?
> > > >
> > > > Hi Yosry,
> > > >
> > > > Thanks for taking a look at this series! I don't think we're able t=
o
> > > > do this directly in lruvec_page_state()/lruvec_page_state_monotonic=
()
> > > > because I think there's still some places where the node stat and t=
he
> > > > root memcg stat are not guaranteed to be equal.
> > > >
> > > > The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_=
B
> > > > and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
> > > > can contain memory/stats that wasn't actually charged to any memcg,
> > > > which I think means for these cases, the node counter values can be
> > > > larger than what reading the root memcg rstat value would give. The
> > > > functions I was looking at were account_slab() and
> > > > memcg_slab_post_alloc_hook() where the logic adds every new slab pa=
ge
> > > > to the node counter but the memcg stats only get updated if specifi=
c
> > > > criteria are met (eg the cache had SLAB_ACCOUNT set or the allocati=
on
> > > > had the __GFP_ACCOUNT gfp flag set and the allocation was not from =
a
> > > > root memcg).
> > >
> > > If it's only the slab stats, it probably makes sense to special case
> > > those instead of the rest of the readers, right? It would be nice if
> > > the default behavior is reading the node stats that doesn't require a
> > > flush.
> >
> > If we were to special case it, it would need to exclude more than a
> > couple, I think. I asked a LLM and it says NR_KERNEL_STACK_KB,
> > NR_PAGETABLE, NR_SECONDARY_PAGETABLE, NR_VMALLOC, NR_HUGETLB,
> > WORKINGSET_NODERECLAIM would also need to be excluded.
>
> Interesting. So for all these stats, root memcg stats (from
> memory.stat) is not the same as the node stat? They all draw a
> distinction between "accounted to root" vs "not accounted"? I wonder
> if this is intentional for all of them.

I think there's 2 categories:
a) the allocation isn't acccounted to any memcg (eg kernel page
tables, hugetlb when hugetlb accounting is off, unaccounted slab
caches and kmallocs w/out __GFP_ACCOUNT, and most vmalloc). These
values only get added to the node counter

b) the allocation is accounted, but it comes from a task running in
the root cgroup (eg kernel stacks, user + secondary page tables,
accounted slab, etc)

I think a) has to stay as is since it's not linked to any memcg. For
b), it seems intentional from the original commit that added kernel
memory accounting logic (commit 7ae1e1d0f8ac ("memcg: kmem controller
infrastructure")). The commit message for that explicitly says
tracking kernel memory pages to a given memcg "will happen whenever
the caller includes the flag __GFP_KMEMCG flag and the task belongs to
a memcg other than the root". (__GFP_KMEMCG later became
__GFP_ACCOUNT). I wonder though if this was to avoid extra overhead
costs (eg for systems that don't use cgroups) on the hot paths, since
it would need to do non-trivial per-object work. If root read the node
counters for the stats that are in category b (excluding the stats
that are in both category a and b) instead of going through rstat
(which is what this series does for the LRU stats), there wouldn't
need to be any extra overhead at allocation time, since nothing would
need to be tracked.

>
> > We could add
> > this special casing in, but we would need to make sure any new stat
> > that gets added in the future that belongs on the exclusion list gets
> > put on it. If it's missed, the failure would be silent whereas with a
> > separate helper, callers have to explicitly opt in. I'm happy to go
> > either way though, so if there's one way you prefer, I'm happy to do
> > that for v2.
>
> I think we probably want to first understand if these stats are
> supposed to be different between the root memcg stats and the node
> stats first. Personally, I think the default should be the majority
> behavior, which I think is that node stats and root memcg stats are
> the same, so I am leaning toward explicit opt-out. Let's also see what
> memcg folks think.

That seems reasonable to me. memcg folks, do you have any thoughts on this?

Thanks,
Joanne

