Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4E7CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFE48E0005; Wed, 22 Oct 2025 10:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FCB8E0002; Wed, 22 Oct 2025 10:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB56A8E0005; Wed, 22 Oct 2025 10:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 986328E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:06:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D09B88CE1
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:06:29 +0000 (UTC)
X-FDA: 84025925298.26.85DB5F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 84C93C000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:06:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lvk83wxY;
	spf=pass (imf22.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761141987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpAlIpSy8C909YLuQA//DQkPxxMEs4xSi+qjURZtgFE=;
	b=Xn3efz7tWkHWRj1hxcDtu7c7/D67r5oOBohXHPt7XR4i5EADJ/7rcZfrpaedLvujlco28y
	ICteZ6e9pwGpt9Zgzn1Z7rMgEs4mP6HMt6A4Qj/cyYhsmD/X97/92Dd38z3vv8uvy1nPtR
	6rYCYld8LY7t4uunNYbTnEZImgmkWU0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lvk83wxY;
	spf=pass (imf22.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761141987; a=rsa-sha256;
	cv=none;
	b=5R5IffUinYY91O6dWZ3A2g5LpOxETWwrjf4F64GEpVJ9gz+Sx5qAbxMCps6qK2Du4VfXfL
	J/bjGlyr6VaY6t3nBZRgUm+YqgXd2dT4JAWVNqOlvRM+Wm8DEYUfdUqTXR4r71YuYLs7Ba
	wDmVfzi0QBI8i59Lm6QwkFDeKm9mN0A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761141985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VpAlIpSy8C909YLuQA//DQkPxxMEs4xSi+qjURZtgFE=;
	b=Lvk83wxYi4pk99ioCbACeoxU0lBmsNANC5rBC1o4fhjvjwOrzni5E/tFpmHRuaDbgPvbpf
	j2ePEbimjeQ6FWwLgR09aCVJNkypLTZAgdXLcWfX1Ad5gDTlMz0eiSsCufZAZOULwXb8fE
	J4su10kJMlYebTP8HQA60Ay7T3u2or0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-g_CuqDnBPOSi7I7X1tGGQw-1; Wed, 22 Oct 2025 10:06:23 -0400
X-MC-Unique: g_CuqDnBPOSi7I7X1tGGQw-1
X-Mimecast-MFC-AGG-ID: g_CuqDnBPOSi7I7X1tGGQw_1761141982
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4e88a5e70a7so37720321cf.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761141982; x=1761746782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VpAlIpSy8C909YLuQA//DQkPxxMEs4xSi+qjURZtgFE=;
        b=kMzFp6VLnpZihzz83FPqv7YAtp1owAthJvbysjjgcfb7pAq6nYFHQAAXODO4LDut6W
         EyNZqfAZwdhM5vNlwsewSFEm/yF5ZVlotmzqj6DsrzYH1bFYqXeh9VIS8Ew4NnMmn0UJ
         I0KahB+LB/sutXKD96e6bvSeOlxwq4iPjg0C4cFeLwK6c69PvqhqKWSxe5rhyxYH14rZ
         +BpMbQzmjjsiQDWW4/lyncEzXAi+qEXQgpanE0pvVPqxHga9n1qrcBXHZSRAeNYZKyBr
         vDpnZ39YJnyEvOBLofXhtG2GNgMoX5H8Dhcbp6Q/gim0DTxtk8UwHzgsZzynDPkou508
         o0/w==
X-Forwarded-Encrypted: i=1; AJvYcCVtDj0+1Kc1cWBi1VY97mRNUUMz3RIpnh9iUpOB90FCRRPooLEK9Go6PMCsTsfAZSp8XSIHuUnfOA==@kvack.org
X-Gm-Message-State: AOJu0YynqYgog/Zal9kLFcBSwDFkrOlljhF/a1iG4VdkRrM2H3olhRkH
	Sv0q7Rqn/7cRI1L/ije1qJDp3vjolLQ6c7BukTScW5Xx3/tlpnegLBcuJsJ6tpLQplWbgzEf5Bg
	24x60NFCokJ6KrlSbjSEo0ukbHygoWByT+h9yFDRKgEUvH5TL6jVaVp94OjnI5UudPd68d1F9kK
	hYLsF+kgdrJ32wXJANDH5RQrPVelc=
X-Gm-Gg: ASbGncu1QMjtLbSfyP4KiXz/zrE13jeBrNTblyEGCMCTRee61Ywl+jN0P4vu4Bousiu
	MVQiw24D57TRruJKUniSfS7NjPWKRV6SEgxCABRsvfaa7U6lIBlP66JpqL0moRcGwJzLJTSdpCc
	T9R95OI9xRpqcsnEoIXZjJSCCBV8pujzECGj2lHWShd55hH6nNEqLmrANJw35QJLR1yarxw0mJg
	DZE7CMWKT6Bs+D9
X-Received: by 2002:a05:622a:13cd:b0:4b2:d40b:997 with SMTP id d75a77b69052e-4eb784b5ddcmr17972991cf.11.1761141982115;
        Wed, 22 Oct 2025 07:06:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiy688lq0byckzl7pGXnvWhZZPJXPo0bl3cEscD1D5tdzpAQ54kYl/qCOsifbFz5e/sCUwL37uFix9NhXMCD8=
X-Received: by 2002:a05:622a:13cd:b0:4b2:d40b:997 with SMTP id
 d75a77b69052e-4eb784b5ddcmr17972311cf.11.1761141981436; Wed, 22 Oct 2025
 07:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <2025102111-facility-dismay-322e@gregkh>
 <CA+wEVJZEho_9kvaGYstc=5f6iHGi69x=_0zT+jrC2EqSFUQMWQ@mail.gmail.com> <2025102124-punctuate-kilogram-da50@gregkh>
In-Reply-To: <2025102124-punctuate-kilogram-da50@gregkh>
From: Gabriele Paoloni <gpaoloni@redhat.com>
Date: Wed, 22 Oct 2025 16:06:10 +0200
X-Gm-Features: AS18NWBUEXjvL5a7yuhDD9EBuivsDI4OlQF-1ILxjqzVH4-eCsEPHeuZ9-Q2Dr0
Message-ID: <CA+wEVJajSGzb85YTiv98yAY3bcJFS0Qp_xjLc++wnU8t=wDAOg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] Add testable code specifications
To: Greg KH <gregkh@linuxfoundation.org>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fq2z3vtz6EyhlGCTsqfzn3xVcwb8tzpq5gng2pe_Q_s_1761141982
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84C93C000C
X-Stat-Signature: 3c3xon3rr6auujyut6c3qrjbz1fjpzwz
X-Rspam-User: 
X-HE-Tag: 1761141986-922830
X-HE-Meta: U2FsdGVkX1+noa23n9JTXn4zf+B3OnvazB5aF7yH7FgsZVV6rb8mR6ytM15peY283QP+Mfr9Npa/huQC9puiQ3p0UYWFAqY9Cx5k98FUMh1EDbMmgpjy/u2MBda5+nOryi9hPEe3C+CgV/5VSP4nMzwe4L0b6E9Mzq4ypUTsXIaGNZAKLvhKOQJNK1vpYAUqmC4xchJF0H6L6YCX6SNRuraMZnf3KY1fG4JC9mTg9R7VXXoApuPSwMg3e25eU9GqRvMwEZI1U7a98RMNiZzYWcQ8r+0g1Vt8RQux0706JyxlFndPNzR3fmoJzhCzk/6wLXOT7la91jpTLIaWrtoVqu0vUJbW5w9IOPLhUFdmsw4cou/vxqKqbJnAzke9en1ZLBlTKjImC7T1B5YlG+3ta023g1X2vhD5Vol86Qo8nmkwv9iEsrv5U3A/ImDl/NNmCtjUi0g++EfT0erPk0nK1AfPVMQMhLiYhD64DR1VqAcBLcCym+9PA79Ggd94ACfa/80cHlxOeT3/AqLqStb8qMmLWwkY1R9I26VyVDDiDjTg1xJE9c8iBj/7C2ndeLFattGIWFZAcaPEcOOfTjQsAreoLCU/1XXnZfgT1aJjyqAtef1YIRtdjS7y85RQau/ILBF2ZodfRUD1H14EIsDVagfJu5ntBu6W+b/GqdE0Kgy0crIKAtyFk+y0XyoYA5sfp7ZKHqrsZbPL94iukNkzMyt8xlhC7RV7m8iX99GCvpOqtv/Fgm9h9xCNnMPjAJAzeTu4wpuV/xlzQYhp7fs5VJdcqmzmCalM5USIOyEqS7oonWfpIcPr6LFTPyHqg8PCndjRskgdDeOBvT5SMEKpZn0GnrJc+CqyG8Gtdz05cxUeunQc4Qb1zhmBeK7Q+J0yhssxn8631ND71eqp7u9JrDVswN8YBY3g/He22y7AaPhXw/u6eDhH4W69z9h3exMeZKheQEE9dOPflNyouY8
 LBPXQVgv
 iBIbpNsUahbn66D8UGgd0yKiAmmHZZVtAjRRa7Pe4dmYk8hlvjzaDapLxLTcuN/nHRq2Gyg1iFvG9s6l8jqU5+v+JPAgoqzOjX5nehcv4avWAG5uVpFrdydgGJz1biFjS4pjZkfCHRSK3NQzKQpBUlcqFn+CIMo9Y4uqHkzOUd4Hqr10zU8B5yPKpoG9fyiKi/8nq9zNH/PzUKCJ4oq75P7NHuih1wg8cU995L0g5Qz1+lrUJx0Y9RgzpXqEWWb92NG1iwTe3GVKXFsOZEzIZ3wj1Mb+409NONbot1wlicfVNeLz96eALiRSzg9WmNT3ZdY455FwybA5rXHTPaRvSbHu+PljqQ50Gw3oZ54ASbMuTT0PBaJKe7+rOOOo1xqZ/8iRidSjnnxoaLS5d3+aA912FcQlvIieuiFeaR9CUs5Vym1lR+rg9E0BDbtak0/BQXzfONyuwmLARysjfBy2tyYBSxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg

On Tue, Oct 21, 2025 at 6:46=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Tue, Oct 21, 2025 at 11:42:24AM +0200, Gabriele Paoloni wrote:
> > Hi Greg
> >
> > On Tue, Oct 21, 2025 at 9:35=E2=80=AFAM Greg KH <gregkh@linuxfoundation=
.org> wrote:
> > >
> > > On Wed, Sep 10, 2025 at 06:59:57PM +0200, Gabriele Paoloni wrote:
> > > > [1] was an initial proposal defining testable code specifications f=
or
> > > > some functions in /drivers/char/mem.c.
> > > > However a Guideline to write such specifications was missing and te=
st
> > > > cases tracing to such specifications were missing.
> > > > This patchset represents a next step and is organised as follows:
> > > > - patch 1/3 contains the Guideline for writing code specifications
> > > > - patch 2/3 contains examples of code specfications defined for som=
e
> > > >   functions of drivers/char/mem.c
> > > > - patch 3/3 contains examples of selftests that map to some code
> > > >   specifications of patch 2/3
> > > >
> > > > [1] https://lore.kernel.org/all/20250821170419.70668-1-gpaoloni@red=
hat.com/
> > >
> > > "RFC" implies there is a request.  I don't see that here, am I missin=
g
> > > that?  Or is this "good to go" and want us to seriously consider
> > > accepting this?
> >
> > I assumed that an RFC (as in request for comments) that comes with prop=
osed
> > changes to upstream files would be interpreted as a request for feedbac=
ks
> > associated with the proposed changes (what is wrong or what is missing)=
;
> > next time I will communicate the request explicitly.
> >
> > WRT this specific patchset, the intent is to introduce formalism in spe=
cifying
> > code behavior (so that the same formalism can also be used to write and
> > review test cases), so my high level asks would be:
> >
> > 1) In the first part of patch 1/3 we explain why we are doing this and =
the high
> > level goals. Do you agree with these? Are these clear?
>
> No, and no.
>
> I think this type of thing is, sadly, folly.  You are entering into a
> path that never ends with no clear goal that you are conveying here to
> us.
>
> I might be totally wrong, but I fail to see what you want to have happen
> in the end.
>
> Every in-kernel api documented in a "formal" way like this?  Or a
> subset?  If a subset, which ones specifically?  How many?  And who is
> going to do that?  And who is going to maintain it?  And most
> importantly, why is it needed at all?
>
> For some reason Linux has succeeded in pretty much every place an
> operating system is needed for cpus that it can run on (zephyr for those
> others that it can not.)  So why are we suddenly now, after many
> decades, requiring basic user/kernel stuff to be formally documented
> like this?

Let me try to answer starting from the "why".
IMO There are 2 aspects to consider.
The first one is that requirements/specification and associated tests
are valuable in claiming that Linux can be used in safety critical industri=
es
(like automotive or aerospace).
The second one (that goes beyond the business need) is that the duality
of specifications and tests VS code increases the dependability of the
code itself so that its expected behaviour and associated constraints
are clear to the user and there is evidence of the code behaving as specifi=
ed
(I already tried to address this point in [1]).
Some evidence of improvements can be found in the experiments we did.
E.g.:
- this [2] is a bug found in __ftrace_event_enable_disable()
- this [3] is a code optimization that came as we looked at the
specifications of
  __ftrace_event_enable_disable()
- here [4] we have documented assumptions of use that must be met when
  invoking event_enable_read(), otherwise there could be a wrong event stat=
us
  being reported to the user.

Finally the need for having specifications/requirements associated with Ker=
nel
code has been already discussed at LPC'24 last year ([5]) and we got a thum=
b
up from some key maintainers with initial directions (hence we started
this activity).

[1] https://lore.kernel.org/all/CA+wEVJatTLKt-3HxyExtXf4M+fmD6pXcmmCuhd+3-n=
2J_2Tw8A@mail.gmail.com/
[2] https://lore.kernel.org/all/20250321170821.101403-1-gpaoloni@redhat.com=
/
[3] https://lore.kernel.org/all/20250723144928.341184323@kernel.org/
[4] https://lore.kernel.org/all/20250814122206.109096-1-gpaoloni@redhat.com=
/
[5] https://lpc.events/event/18/contributions/1894/

Now I'll try to answer about the goals.
I do not expect to have all Kernel APIs to be specified according
to the format that we are proposing; my initial goal is to have such
a formalism to be available in the Kernel so that developers that
need to write such specifications have a guideline available.
For example today we have a guideline to write kernel-doc comments,
however (AFAIK) patch acceptance is not gated by these being
present or not.
I think that developers having a direct interest can write such
specifications and associated tests and these could be reviewed and
eventually accepted by maintainers.

>
> In the past, when we have had "validating bodies" ask for stuff like
> this, the solution is to provide it in a big thick book, outside of the
> kernel, by the company that wishes to sell such a product to that
> organization to justify the cost of doing that labor.  In every instance
> that I know of, that book sits on a shelf and gathers dust, while Linux
> is just updated over the years in those sites to new versions and the
> book goes quickly out of date as no one really cares about it, except
> it having been a check-box for a purchase order requirement.

I agree and in fact a key ask from maintainers, as we discussed at
LPC'24 in [5], was to have the code specifications sitting next to the
code so that they could be maintainable as the code evolves (and they
would be even more maintainable if specs come with tests that can flag
regressions as the code evolves).

>
> That's business craziness, no need to get us involved in all of that.
> Heck, look at the stuff around FIPS certification for more insanity.
> That's a check-box that is required by organizations and then totally
> ignored and never actually run at all by the user.  I feel this is much
> the same.
>
> So step back, and tell us exactly what files and functions and apis are
> needed to be documented in this stilted and formal way, who exactly is
> going to be doing all of that work, and why we should even consider
> reviewing and accepting and most importantly, maintaining such a thing
> for the next 40+ years.

Putting business needs aside, I would expect maintainers, today, to
happily accept kernel-doc compliant code documentation as well as kunit
or selftests associated with the code; simply because they add technical
value.
If my assumption here is correct, having these kernel-doc specifications
clearly formalised should be an improvement for the maintainers (since
it would be easier to verify incoming patches when specs and tests are
in place and also it would be easier for a developer to write such
patches).

WRT the scope of code to be documented, I expect that to depend on
the vested interest of companies contributing to it.
The directions from the LPC24 session were to start with some pilot
drivers/subsystems first to define 'how' to specify the code and later
focus on what and scale...

>
> > 2) In the rest of the patchset we introduce the formalism, we propose s=
ome
> > specs (in patch 2) and associated selftests (in patch 3). Please let us=
 know
> > if there is something wrong, missing or to be improved.
>
> I made many comments on patch 3, the most important one being that the
> tests created do not seem to follow any of the standards we have for
> Linux kernel tests for no documented reason.
>
> The irony of submitting tests for formal specifications that do not
> follow documented policies is rich :)

Thanks for your comments and sorry for the mistakes, I see that Alessandro
replied so we'll pay more attention in writing tests in the next revision.

Kind Regards
Gab

>
> thanks,
>
> greg k-h
>


