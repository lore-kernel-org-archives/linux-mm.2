Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1ADBC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41786B0088; Tue,  1 Sep 2026 16:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1E46B008A; Tue,  1 Sep 2026 16:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908476B008C; Tue,  1 Sep 2026 16:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 602C66B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:59:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4B50C0534
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:59:53 +0000 (UTC)
X-FDA: 85166410266.29.CC89AAE
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1AD016000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:59:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=nPX1JDv4;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788296392;
	b=Fcx97YDy8VB07fhEfwoIOv8EDOaOlLWVFLXDxNEIaeFarW+EvHlaeZr9PA1Hb9q0bdd5h5
	ASu99CeidZ37To7IX8ieZ3mYp/I9Fkzd+hfnPUCUgAQYsgLS1atNt/aIdKMqEXlNelTJmV
	oOBif8KeJDoCY/bB0x4WfjJB1iImleg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=nPX1JDv4;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788296392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scAaW2u08X/6xoYYfzAu3cY9q95BQA8pLakjGEvGhLQ=;
	b=Y5YdarXdbFRRPfDfruoyTdOVrufgiIa4EqpITraAu7n4TCqC150Xurl4HNdRk1HOIaMhLu
	cfY32Yc6hZtgeg618U3vk0/vhcC00rhH7uEDBBhC2NYVvraDEHNwet0+riiM/VoyoTzwRW
	NCkYBjyJhDMZNgiakNp8L3NuVEEL0kY=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66c711b7f2aso344647d50.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 13:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788296391; x=1788901191; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=scAaW2u08X/6xoYYfzAu3cY9q95BQA8pLakjGEvGhLQ=;
        b=nPX1JDv4kNn21LuUgtnNTR94PjNnQkbSYJH8tj8dOf0NLDjDe3xlJgmBjMlpGW0Jv6
         TTIEBjZuv4azbXL/adThoqlvZhhBSyXB7DNxxK0Mbp1LHodPtII4qu7mn/XsTHy68c/V
         o/TeO6DNY1qLXII9Hk5HhvAg2+QwXEhle8cgTcz24SU3yDxffa36JxLaClrX32MVVRGh
         FJqx49X6mpxjLoXUlb27TONwyPzarDoTgp+4sRFry4FL75TqcaNySqadRGgVGzLhy/pX
         IeU+zTc1fjCW3I6MpsuNtbZ5f4UVI62Hd/cbT5LfUoK2V09f+6kxVZInpwWClNkUDntk
         0Mrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788296391; x=1788901191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=scAaW2u08X/6xoYYfzAu3cY9q95BQA8pLakjGEvGhLQ=;
        b=SLHnTtADOIgMeAbpWeAXeFt1p8qON9N7eCq1284s+ZNOekA6isrY5XtFMlBufaIO0i
         mtDEQ8MZ/proYy6XKGoXEpjufRNpO2YYSoAC1jeVR38FckQvU6+DVROdpbSMkc7jfMaE
         oKnqP6/3r3hgrimUxFL+vs5VUGT+2/HJPLeRcdipI5Ve2ZUK8Sr+8fXFdfzmwUPBT7nr
         MyYnAgOYJx5elVhD83PbLtd1CAq007EdaA0ttzmqlaLNVIGb3mqD389LesTtbCaA3uzu
         bALWInDYCcKp4schgLfS9MsTiv7C1PUDztqQbpsi6PfIgToA8XOsDRC5sMdn092qS/ti
         i1TQ==
X-Forwarded-Encrypted: i=1; AKwUvBwp0KaNJp+Pzes4uf0YKUnkc6f5WwOViJ5Gj9ttoawUtbUsXiyRj0DpjGCn82bHKL6niGRrwJENvQ==@kvack.org
X-Gm-Message-State: AFuF++mB6FDR/72GJcL9YJeSDe7u7vAusqMVU4qBnuE7kicZBStU2XT1
	/wSyGwQdINDlzv1MrPSM8qUPkrR4HDuq1RuZ7lFUGtIGJjptdOxQwKl9TM66lU4GZQA=
X-Gm-Gg: AYBFou10XnJelfL969wOJwyX+ru5/4PlZsAOEBomSIKN9mfPeX5/NG7luYR08KRWKqR
	LrAJ64S6gCwb5a8jYC/cw+glpbiTsn5viWNoxgA1tfVYAKdWhnsjieVBc8Svnfcz4oxfmGHCNQQ
	jFE2j5+ksY/Yd50g79cD4G6pscT+gLHmhvtjjGmoxslWpMEyQfm8Tfg8DgZ80t37r19EaN46b3p
	AoWf3YzFih5sFJfbh1cFP0dXSQ912OZ83KxsJOYxg0LwevuhFh1sSmniwkJLcPCJKpKXcAbOq2t
	lnh1dtCx7s3PG6PLBVIPg1wY9cdcun/sZ6mFr4bmZh4JnGOdbOu+5w96xedjbOLPlZ0Fdkg6u+J
	XRm44zWw9rSEPNny53YNBe8FnTr+AqPJxHVzx6mtI90JcTxuX2AAwimnROMuZ10Dj4s4qg0l/zI
	7fsdYNuiVIk6CpkTK3cenTqypcIo7ythdnEHMkKfW5HxzfTjCAnvXg03j5u7iH
X-Received: by 2002:a05:690e:1347:b0:66f:8a2b:3db1 with SMTP id 956f58d0204a3-66f8a2b40ebmr2730463d50.46.1788296390661;
        Tue, 01 Sep 2026 13:59:50 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66f986afd80sm444525d50.20.2026.09.01.13.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 13:59:49 -0700 (PDT)
Date: Tue, 1 Sep 2026 16:59:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.com>
Cc: David Stevens <stevensd@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <20260901205946.GL3004@cmpxchg.org>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
 <20260901142552.GG3004@cmpxchg.org>
 <apbyZgB_Zu-DK8pN@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbyZgB_Zu-DK8pN@tiehlicka>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C1AD016000B
X-Stat-Signature: ujcbc6z8ccoup7598ipz9iahdtah8iar
X-Rspam-User: 
X-HE-Tag: 1788296391-967480
X-HE-Meta: U2FsdGVkX1/Q0D+Lq6glJ1EfgYJqgTRr+R5KZoRkFB5CD9VFlRINs1NwBOdXG1uqbzOMlUqQcJYzXbNYkuP8AwKr2RcWWdx+aZT/s2VQFXoluAZZtmooPtbK4GFf04wBRh+jY0MEQNHuv+3xPN5vORREQZccTZtFyOqEXLA7G6ZI5/79iONDzHbfihCop0p+7FQ4VOnZt9bWZ6s6n6aonAuIzSERXqFOmW9qyfpJLn21ZQXOKsYtRbcXXEcyzysBTlWV5qpcrzAno3j9S/wZ9/p59/yEgso8sLZAh0lXDG1mEXeecjORcZZl5n5txUk09i8R0zQqNZ8sibk26OrSIoUMu5sf/LiwxReDHtglZ29ZqSG/uA9kQf1BqRKiimXj9oIJR0vOIb0K7KcQeCIyGyqV/R3DdjJthgtgutg0SF2BzqRLP7fJQSVHbmi9hetpi0FcxMZTWCggrAo+bMDmG73MfUqlJVwAK/XvnAXnO5d5miTpg3BUCTydAhuXfB+Ud5wf6zmKta8lkNuFYvPOE1O96PCKkuff/P/rBHm64FXvwmGQ1IX4ptL4FyZt0llmg/SCjkN2v2W2HATrV0+cvJSKr6FnPKjb/n7rAyxRPcpdL6pvNiHo4cN+8aSkGGIa0UG4GzUxQRnTjY8WMzJYhNRzgfT1P+fI8XjcRw+T1qCXjIFzPnclFkbZhUF0qtfwpGbOgE6bZwuqDJaZH0np9T4EO17GYI7ZFbesgcIcsitdpKFRbbdyNz26uiVFc1vWW6rEBo/T76hTQkm/zemxi5fDZ9B+xe3YFMQG1fSR3iHihAvdZmggWMW6QxBPWW9vX2z0ifuZo6Ez4qozMIyKEKsV26/cl2kMNbuCNNuH3Ef84S8l4Yvnq3hZFOSQpRjUYEaP4t7o+GR211x89sLCZAc2/YI1p2WIfRI7pzPqr2RoFxufNiA1ogt8NrNvnI36g5Yzq/Rp7axWFJi8EmR
 1IJq3Dha
 R/vY01CzLfL547t+WnW0mvGtRC57ktSWD73iKheX3KW/KAF6CT2CSDNCCpnl3rVaycZaVaabbQpmDnTxy6pZEnWtUXP7SCITaX7xu044/P5ycT6d00Xv08YhT7BL2BJtL4vYXXMF9GGTVtaKEuN0D057GsWAcWtp1dPlAUgiewdqtjN4TpwS98HesIxj0n9Z8Zc3Lji3UQwPKyxvmPJB3PPQqcGJGb+7ExLW/ZwrRyjAD0/6+06fNtLATXi4oxfMX17od11HOmlmxXxM1os+wqcpAs4vsCQ1NPSFfd3kqjlrfEX3V33cIy1+C3DMOQyurA/2J3wnxH+11rlhS0rAm4rGqY5MrwJFc5tx4MW2voGxqJe0K4zV9JHL9mtTCltWtL+b1FzdSGhGEgaLZINLdfSF9BOYJ/1d9s6ynJS8JTwLN/gQNUNt3oZlX3inLTFpl6e/I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 05:42:30PM +0200, Michal Hocko wrote:
> On Tue 01-09-26 10:25:52, Johannes Weiner wrote:
> > On Mon, Aug 31, 2026 at 06:04:57PM -0700, David Stevens wrote:
> [...]
> > > There would be no guarantee that memcg reclaim would ever be
> > > triggered, which also would also stop MEMCG_HIGH events from being
> > > generated. Overall that seems a more serious than just dropping
> > > userspace notifications like is done for MEMCG_MAX.
> > 
> > I'm leaning that way too. It's an indefinite error, and it's a freely
> > programmable surface.
> 
> I am really curious about the indefinite error side of things. It has
> been my understanding that these NMI safe charges are a) rare and b)
> there is userspace running so eventually any discrepancies would
> resolve so the excess is temporary.

So I think the question is what limits the error in both space and
time. When you say it's rare and userspace fixes it, it basically
means the answer is: luck of the common case.

But that doesn't help the worst case that can be triggered.

Like I said, if we need to have code to handle that !allow_spinning
case anyway, I'd rather just have a few lines of working code than a
(lengthy) comment explaining the luck of the common case.

