Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2538106FD60
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 01:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D8B6B0005; Thu, 12 Mar 2026 21:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7442B6B0088; Thu, 12 Mar 2026 21:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D3C6B0089; Thu, 12 Mar 2026 21:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 549956B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:50:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA43B1A0628
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:50:18 +0000 (UTC)
X-FDA: 84539359716.27.B177EAE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4F606140007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:50:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f6iO2DxB;
	spf=pass (imf26.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773366616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8qvvOJTfwWE8tG5TRMJ16Dwr1E/YePgvm9DgBu+yJg=;
	b=UQhVo1BqIImackUIKWd7v8P8teLZVAE7JRMEhnea9U8sbAKmSFNKyp8QgcLxIxcIksogV4
	knIgVy7sk3K1bROPp1UI2cU4XfCa8GpSsN4/0QaKtNk/5jLe4Js+YDl5CJq8AMMnP12M9B
	QMcvHhry/7+t/OkfIhSXFtZv6I/FhvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773366616; a=rsa-sha256;
	cv=none;
	b=1v38s7TU2VeqgW9uA3nKu15ba/48SOdttQco/Fu29uH99GBF0OdYnaHb9CDupV0CnSVkpm
	QCt6XGa/O16p33brOcoyJiRBEELJtiuavqVB2CkC6hv6d0e6r9fLM3rLTaDfNmvD72PopR
	F1gvksVEWU1ZsIeEWW7uCl5twKiqLn4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f6iO2DxB;
	spf=pass (imf26.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773366615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8qvvOJTfwWE8tG5TRMJ16Dwr1E/YePgvm9DgBu+yJg=;
	b=f6iO2DxBbSdtR5un4FV57aN2TTWj3mxJgS0+AkMERY731nYm5a6afd9pYaN3dzUMUgQ6ob
	N6e4vyD0cJv1CGJaItCel80+Hesjq0ycclIBTeDlcReot9EX3erWp6FKj+R1Ob7yvcEcK3
	lhmkaicbSKLWWoLW+/JS2RNK6LpvK64=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-nPIhttV5M7-fskDbVElQSg-1; Thu, 12 Mar 2026 21:50:14 -0400
X-MC-Unique: nPIhttV5M7-fskDbVElQSg-1
X-Mimecast-MFC-AGG-ID: nPIhttV5M7-fskDbVElQSg_1773366613
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae4b96c259so28053355ad.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773366613; x=1773971413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+8qvvOJTfwWE8tG5TRMJ16Dwr1E/YePgvm9DgBu+yJg=;
        b=rBdGJM6AwwBeUAwkqHXo1R+aimjD2Amx+0HYt/9sH9B4M3IMz7XZOLDXD/GAUTn0eB
         69wHczyxFmPxaSv6r7FwVTNOPQ35KIN++TxJq42Ico266hryUzWjs6I/eL4mDeFpPC+O
         t4wdOqd/tt4Ye8LkxwMCu/Z20C8sx0Xcwqff6OJdWmxke8d2HxeGO3MjjwpCWQ215HFC
         OMNBR0AuTWYt2sYhi73Fd6hFK8VHWFTCZaW7a3NqvqprerMErxxRl+bJw7Aakn4ypH3E
         N9AdT68e2Rl0AvSRv6TQ8yxfriwFmLY3a/SeidlGMBEt+jiU1BecpIv7NuD7k3XI0qLV
         gpSA==
X-Forwarded-Encrypted: i=1; AJvYcCXUcyucgNnMbYvo6Z6XapHDJoUynoHU4GIfdksPcVqx1HaWWltHUs63dM03wgHOXZxECx+6Ij6u4w==@kvack.org
X-Gm-Message-State: AOJu0YwdOLrIVDmMDnf8qr/hKpybJeVvvKdelV6QYhvcg8J/2rObR8N/
	+tFeXWjwz8QRBqVYu3nZa84BfTZg0of2AYFihMOxgH04j1jNnGtElSyyNheHLOgMDnmD5vzCYEl
	WggB1ORbDikBcbUTiu+LBKhwsaxildbelEjBPtzr2/92kSBsqe2yg
X-Gm-Gg: ATEYQzzU9FEVgwvmahi6P+epFeQ57wQeQ8/lTnT6ysBodqkZGipUmLaPzOjNj2RwJY+
	7triDvI5zMIQchSBBgbt+N7m2RDnHrV7tQSZLhyprePhb34ErKx9+dzarIMUYAM7dgRJ0JWGncY
	wzxX84toSF+JVKQMZzsa+8KwMq5N3lKdCnaxjebWKkqqdfTShprYbWCX4GMDoNwHHivm+RO52z+
	mwUJI27LJx2r4X2R0rjU0IzDzxACRapMENX/AfcsIytRx2JFZ3Hxw/p/ZUqc3KxhjAscLSetmIe
	tL8mFNLnvpZPBiCudt6pVCm2s0212Fb5ZZHkPyN2YhWgxwdI0XFgWJ3UW77hY7AslPfaZLGuTy4
	nUmPKQVXKyJfBFCaXqg==
X-Received: by 2002:a17:902:f542:b0:2ae:5628:a180 with SMTP id d9443c01a7336-2aeba5594c1mr45919075ad.25.1773366613150;
        Thu, 12 Mar 2026 18:50:13 -0700 (PDT)
X-Received: by 2002:a17:902:f542:b0:2ae:5628:a180 with SMTP id d9443c01a7336-2aeba5594c1mr45918945ad.25.1773366612701;
        Thu, 12 Mar 2026 18:50:12 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56c2b9sm3981305ad.18.2026.03.12.18.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 18:50:12 -0700 (PDT)
Date: Fri, 13 Mar 2026 09:50:09 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: mkoutny@suse.com, yosryahmed@google.com,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v2 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
Message-ID: <abNtUReAUHT6j9Rn@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
 <CAKEwX=MqyGQSMuVCSWmhKfHju5uHBe3ySQEgK9XuKwCvpL4x8w@mail.gmail.com>
 <CAO9r8zPmV8v0tiQvn2xFqX8F2oU23mfbVK67nxMO3QKt49kJeg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zPmV8v0tiQvn2xFqX8F2oU23mfbVK67nxMO3QKt49kJeg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L9OxX4-Z2vWdU0rAeXq0mBnBCAVySOyv66j-8uIZ6-s_1773366613
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F606140007
X-Stat-Signature: 6hbbfji467zkb3jkui14qbne4g4ax8ks
X-HE-Tag: 1773366616-112042
X-HE-Meta: U2FsdGVkX18I59YXWxP/yRn38ogS/3Wbi0YC69CEwP80vOehNG5SMxL1eZ9l1vGFKxKzxiz6cdAGEn8jrUOSeuZfy/pBCurg0gvf2NpY51r/PN1uV/dJD4ODRiLO1qbnpbNT/lJYV632+UmVrW6Qsy9HdMJpTvVuInLom+0M3em4ox39pzgo8gnDu4HkXN04zBLAXZ7YD+pm3QM8qgxiNjaeu8jXcdtVLgPWbII1JA6B3p9j/YVQct0DSKg2KsbzAqRptY44aixudD7zU5K0ZWSMGK3em/kDLi6My0C76ia6Fn4ZqfjwHJCmwM4IOg6zQ/2PvNpBoas0fQ9ufFne+OeffrDu7YcSGGMwfYPSg2ntO2mEXeb7UzEMAWVv2dLaXuoQvGW+Kr+949z7fQBJRODvtlkd0w7AVR7jw9uS81s+iIRoTynHq6B+Yv5T4xh5NoVJm/7E9JlWcUd/NnmNaIt5c7mD0JMej728XiVKPv1aiJjJ7geLWDQoD65HQpSv3hEcR0ppUnZYu5wzfx4akvgXtIVpI9ovFzgIWsGS7OfvvC2pAr1zsXG0zgCsqFaIxjxKa9Ye8YEw9WuFijaNcOndOEiTb5UtsgcHrRvZEpdySjovWnPNNBQZ+NE1QM01vWkBzexu7+FTE7jbCMeAp6seodCcbULsyrE0rZi2cJqNlZI7QAyziC22LJk9dmmGPS65QqDR0eQLxbHBS58ryfOTEz5yLzvCz5rh1UILHtEfYUYw+eYjAP/sdjpsl/DFLerDRzY945GGfqWCuA0cCdbQ8YCuUOLVqaf5CmldAA2gsep1GEhClhy404O20mbYnUcVQrTN8pBpcWIUKZ9gv3KmICtUTj6rTmcekUQ65OLfLimGPjAIxJOyhIfLf62ONN7TfFneaZb7bZwA5IWSvU2/Ocy+Z2xfXij1hGmM0oNBw3lvs9flXw3/YAIaNOhQHEB23mR5BUcop/1SxOR
 fDqegUtN
 H/c0HfvqW9VlN7m5nu9+V9snds1tLFXHMYz7gDX85D+6R0HK6RWivLzZILXpQW5pTXy6FjktN+DIGWx/0iOWgI0cJRJXPAW3cKtJPL8QyxbddxmZo5Xb8I6SwLWiOIhgMwfJSgJpRIftL4fPm4V7Pt6h611KkUP6zInfaRTTeWOtJTQqn1ssAEjosZ7evfbZsDA2xVdk5TFF45VSSwMk4QzuT6oIX0V5YFc3s3ADFGmxcIVXwOh9I/OhpGclXr41vHZ4EdF7YIgGOdn1UyRGNoqJ/CYeM7wofO5MZLXDJov14MHhyvyyH3Kg76X+iWGS9sovqbv7CQYxGBE/WDfBurihglinBA8dacVKoHoZQ9rR/jVcL0Jc8J8IeYd2YY+UlvtsDAzBz3rQOLIBHESyAgURIgYOKAqy4sjNEWw/OU7zBkcSz/7AMhQecnXJf20+sqSxnu8emtrbNMXUiuGOmpAhS4p1DEYZB0pKm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 02:09:30PM -0700, Yosry Ahmed wrote:
> > > diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> > > index 64ebc3f3f203..ec64daaa2f5a 100644
> > > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > > @@ -589,23 +589,41 @@ struct zswap_test {
> > >  };
> > >  #undef T
> > >
> > > -static bool zswap_configured(void)
> > > +static int zswap_enabled(void)
> > >  {
> > > -       return access("/sys/module/zswap", F_OK) == 0;
> > > +       char buf[16];
> > > +       ssize_t n;
> > > +
> > > +       if (access("/sys/module/zswap", F_OK))
> > > +               ksft_exit_skip("zswap isn't configured\n");
> > > +
> > > +       n = read_text("/sys/module/zswap/parameters/enabled", buf, sizeof(buf));
> > > +       if (n <= 0)
> > > +               return -1;
> > > +
> > > +       if (buf[0] == 'Y')
> > > +               return 1;
> > > +       else if (buf[0] == 'N')
> > > +               return 0;
> > > +
> > > +       return -1;
> > >  }
> > >
> > >  int main(int argc, char **argv)
> > >  {
> > >         char root[PATH_MAX];
> > > -       int i;
> > > +       int i, state;
> > >
> > >         ksft_print_header();
> > >         ksft_set_plan(ARRAY_SIZE(tests));
> > >         if (cg_find_unified_root(root, sizeof(root), NULL))
> > >                 ksft_exit_skip("cgroup v2 isn't mounted\n");
> > >
> > > -       if (!zswap_configured())
> > > -               ksft_exit_skip("zswap isn't configured\n");
> > > +       state = zswap_enabled();
> > > +       if (state == 0)
> > > +               ksft_exit_skip("zswap is disabled (hint: echo 1 > /sys/module/zswap/parameters/enabled)\n");
> > > +       else if (state < 0)
> > > +               ksft_exit_fail_msg("Failed to read zswap state\n");
> > >
> > >         /*
> > >          * Check that memory controller is available:
> > > --
> > > 2.53.0
> > >
> >
> > Seems a bit convoluted. You ksft_exit_skip() for one case in
> > zswap_enabled(), but return some value in other cases. This value is
> > checked in the caller (main()) and then used to decide whether to skip
> > or fail as well?
> >
> > Why don't you just consolidate them in one place. If zswap_enabled()
> > has no other callers, let's just open code it, yeah?
> 
> Hmm I actually like having the helper. What if we move all the
> ksft_exit_skip() and ksft_exit_fail_msg() calls inside and rename it
> to check_zswap_enabled()? We can also just read one character:

Yes, this looks more tidy than open it. I'll go this helper in v3.

> 
> static void check_zswap_enabled(void)
> {
>        char value;

read_text() requires string but not char.

> 
>        if (access("/sys/module/zswap", F_OK))
>                ksft_exit_skip("zswap isn't configured\n");
> 
>        if (read_text("/sys/module/zswap/parameters/enabled", value,
> sizeof(value)) <= 0)
>                ksft_exit_fail_msg("Failed to read
> /sys/module/zswap/parameters/enabled\n");
> 
>        if (value == 'N')
>                ksft_exit_skip("zswap is disabled (hint: echo 1 >
> /sys/module/zswap/parameters/enabled)\n");
> }
> 

-- 
Regards,
Li Wang


