Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7161EEA84E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 17:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9EEA6B0005; Fri, 13 Feb 2026 12:14:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52186B0088; Fri, 13 Feb 2026 12:14:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DEA6B008A; Fri, 13 Feb 2026 12:14:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDED86B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:14:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 414AB8BFFB
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:14:09 +0000 (UTC)
X-FDA: 84440081418.05.C8B9806
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id CC9C218000F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:14:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Whr8Y2Cd;
	spf=pass (imf06.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771002847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48MPXs8uydZg3IJ9byQcByCwujOFhfoWvJ4s77ZzRZI=;
	b=GckH0jAcsDp4pKwHDfzrPxH5UA2Deu6YWVWnGXyba/uhXlZkdcdbYKAS9wuqqH8jcAo1/A
	7h307Gi27JMAWe+n8Hol0EVDwfj7Ylls5v/vv7mCetHgaXc9g2DfP1uNxSE2QVetpFEoZP
	mol0Fk97OAfNUpfaHBGj7PK9oLkxeFI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Whr8Y2Cd;
	spf=pass (imf06.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771002847; a=rsa-sha256;
	cv=none;
	b=UA/waCFZaL3uI86xu5PEONfA7b8IInc5VMazfC2dY4Iiq7dwzXV9PzkXQCBnr9W2oa1OXC
	T3SGCk27MoSR+cpMmL2chPLAxF6NzHIEH3YfYOGEyWRgLoEYWBZUshZQV+bEDwi2ZbxMUL
	BjiHFVzv0wbAC+4uUeM8q2CVhiWGXVQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771002846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=48MPXs8uydZg3IJ9byQcByCwujOFhfoWvJ4s77ZzRZI=;
	b=Whr8Y2CdmlGrenDIzsMV2++iD+6BHW50szaoscP6FgzL+C87fWXEXzc6s6se9IjikGmptK
	2FTAkNzbSeBQayOPMs54f+AaPGAWP2yFwFmzvhYMluTadfWgrlSOfV3A/8ypvxnJzomyLy
	dyFQj23LxmieNDm7VJmWccGM/qx6XXs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-QYp6fm_cOOiGeh94_Aj3kA-1; Fri, 13 Feb 2026 12:14:05 -0500
X-MC-Unique: QYp6fm_cOOiGeh94_Aj3kA-1
X-Mimecast-MFC-AGG-ID: QYp6fm_cOOiGeh94_Aj3kA_1771002844
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-506a07740bdso83307001cf.2
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:14:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771002844; x=1771607644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=48MPXs8uydZg3IJ9byQcByCwujOFhfoWvJ4s77ZzRZI=;
        b=s78e8n3QxidJRKIlMo8Y76gM5VM4IfXDplVxwOYdKWeuB//laL7qKre0VywUzbu33u
         Fdf0pn1osL9Okxs838SoYlYXAAD3plRqNuR7kmiCDcnabcjl7hAeQiVBZKDPTOf95Qe2
         hlxSV4tKhNQaEYW2FLIMloAc3S4SBv/zRb/lPnaxzWdSXr/oDMjH6SffB6OFC7cFD3ki
         CGlzngIL85rvwcwsuvz9PJ7xZFN5aPG+vB1rVGEoDcXVRe27rmZMn2gq3NEkT6wNttvo
         Ok3cMvS7Z+Az9F3qS0b3aLkBn2VRZZVQmhirrLoIP6RqoDFbvokl+wsulfjSz9OgOKKH
         GBZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfb6Vt924srV5IcnevSM4zvzFytupXNilns3gHxgvdE01+GOJ2+s66myPhlXDsqhItUVN0QbllPQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7K2HARnN0IdH2xhuigLk9u5RoGS/25291allcdM+K4DkdwwAo
	XpovYDco2f9H8LNzPf0LBnxk1ILJB+rEXML2/40xELJeVmBKAK7kTwNcre6kmZhq57O6HQARhyn
	TdIF2us1HdWAnSOninh5nzioRUr76EQkzqDThpyC6hOje+D1fA4+S+mPF7vclksS4q8eZ/h2R9K
	cCKAW+BdZLnSXFmb4uBjOP7NVdU34=
X-Gm-Gg: AZuq6aINAPDHLTLP5jOYddqKX//fvq4ZoglvxSlkLyqb7+2AKOX+cEv9/ThPjbJWdAV
	y3yn/zc6jZyMDJhIXguF4LCA4psyzy5prOZYh9gUHaqdUymbYGYObvolBeT/fPQE173d7TK8ILR
	QLKxs5Lk+u8DqyjvNrKT31fB0k75eK80GxPgbBKlv53h5ssVACQJyP3ryaMb0+zm/sYtexrS7Hv
	uIa7VPcgV2U+ThbrPaTu3lG0oF9hQMPI4UF4W8=
X-Received: by 2002:ac8:58d2:0:b0:501:4e87:70b7 with SMTP id d75a77b69052e-506b3f7dafcmr2115861cf.1.1771002844081;
        Fri, 13 Feb 2026 09:14:04 -0800 (PST)
X-Received: by 2002:ac8:58d2:0:b0:501:4e87:70b7 with SMTP id
 d75a77b69052e-506b3f7dafcmr2115341cf.1.1771002843486; Fri, 13 Feb 2026
 09:14:03 -0800 (PST)
MIME-Version: 1.0
References: <20260212124923.222484-1-gpaoloni@redhat.com> <20260212124923.222484-2-gpaoloni@redhat.com>
 <2026021221-grading-clatter-b7bf@gregkh> <CA+wEVJaFX4AE5ruKLvgYZhmNsOabovLp=2LAaLUYe5B9r51qEA@mail.gmail.com>
 <2026021207-hatchery-spore-2800@gregkh>
In-Reply-To: <2026021207-hatchery-spore-2800@gregkh>
From: Gabriele Paoloni <gpaoloni@redhat.com>
Date: Fri, 13 Feb 2026 18:13:51 +0100
X-Gm-Features: AZwV_QiiIwRP90JuNH3-RopOFaXtZYGeRpSsElT4AgkFJTEVPZTkMgMRh4ssB44
Message-ID: <CA+wEVJbhtDD2G4V=auecrcTmO9s7bE8VagjMmoPaetASJAh0Vw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/6] Documentation: extend the 'Function
 documentation' with expected behavior and constraints of use
To: Greg KH <gregkh@linuxfoundation.org>
Cc: corbet@lwn.net, skhan@linuxfoundation.org, arnd@arndb.de, 
	brendan.higgins@linux.dev, raemoar63@gmail.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, acarminati@nvidia.com, linux-mm@kvack.org, 
	safety-architecture@lists.elisa.tech, kstewart@linuxfoundation.org, 
	chuckwolber@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JpG6CuJfwtTrNjpkpOIOlgbFygNtDjqdpp1L1iXaY3I_1771002844
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CC9C218000F
X-Rspamd-Server: rspam07
X-Stat-Signature: jzyubjrmxecyimzq7r6phc3enrcd9rd7
X-HE-Tag: 1771002846-829687
X-HE-Meta: U2FsdGVkX19xFNzu7/4q8Pu8Bd7ZI0h4PqiFHFurUBvq5x6AYSionyTyYNbXDsKPdrfKCL2HfcbjUDnwpQcPiCfUEWDCT3XQD2cVZqngTAk5N0hPWExY8xIiKTubwCeEhMSB64pkhlqPt9felQy93wMdoaX/Jjb8ConuYH9y195kMXKdN8ZLS/L5nvMpxacAa1sMhuC77MWzOeskkTZYZoE8op69oC6/sFuBql0WKPyDo+kRl4sDqCw10vpLUhvsJIPKq77jT3diAyXRPEB8y8uO7Mii7BrJSmGNeyBOuW6441166CqKyeYj/+7wvhZHvIdV+T4CjSpWZIA6vH1AoLDQgFYvNz03FPjTPU61f1UkkDzb//+NbqjLgJP4ox/h30DRzpe41FEcd62GgqsenDocNPZYmMa0r4GZA/gDrE4fKvzK2ZUpwH9+JGbvf9l4wawdR9PbukddG0NOmOLSOQirYNCjxzuJyne2yt0SFvZzuEAvaDDJrDnGd7JFvNUXhjDRAUVb2U7kEmxL19kTssWZxYYuU4xISD9UDrOFG2hXXUTASGAJpIeD5RDhVRQcVEepKvePIgE01avJGknnLuF/BMf8yhxvnB4jxbTundxbHSIGEyauoajTcUNqsMRlUY9ZStD40QEFYXChGIik3mOPPzqCMGBdEwK3WtsSv3lRUJ7NOjEZQEF9FthYyxpab9WPDOGm5vYKBKZ+eOQqWgt80MvnTPUNW0Zpjyc3yek3d2Ft0O4Vh6YCto3omsXoXmliMPPS2N2FI/Qx8uvaCk33snoY7ufdSYUTpPD+uBDxGYNtvzzKdaHYEejGjkCz0tSBz0Tg3TyhkNas+AjJNDGeFjn/wSTQ4vgF7YB71Rq036AoYJQ89BC+I9FEoY1DiTkyVmf0fHGgpxMYpwhNbZGZ8Y2H6W2VT0NfHdQyJoPtE2RYpU8jG5Nxz3LvCbw7N5m0WvweO9t0ZbyiyXw
 VzfLQmKC
 NJpHxRDzgGpOsZL6zPMLOQiU2AmKAbt60S1qtM8F8V4QN12KFfVqgWUo2mwzwkBpdFqf7tW6Tc2I+ZBJha4McWlPmzHi/t5ky5uOVCmv73WJ1P5aUovfy9GgDKQ1Yc9bHjxVoPLIOl1MiIGZeKmxfLfHdz38pA7auaVzS2yCGQqvd0/uOgexreGq5m/2oMe/hwCkS0dl8CcGI7HFj8J8IpxG+jxpft6MlX0oifpzrTe1qBS8XW2y8KWMb3EskvQf1fNPHZ1zp7BxkYtDFMJwrv6aYONFQlGzBNTIF60XwqUzoAbn0WB6DGApRODV6eOR7+J6fFm89jmERb5Xfk/I/UHJ0/45pYbLFO15A4YV85y2nuBfq61BjNwGsUJJ+vAiTSdrc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 4:23=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Feb 12, 2026 at 03:00:01PM +0100, Gabriele Paoloni wrote:
> > On Thu, Feb 12, 2026 at 1:59=E2=80=AFPM Greg KH <gregkh@linuxfoundation=
.org> wrote:
> > >
> > > On Thu, Feb 12, 2026 at 01:49:18PM +0100, Gabriele Paoloni wrote:
> > > > Extend the longer description section of a function kernel-doc
> > > > header with an itemised list of function's behaviors and
> > > > constraints of use.
> > > > These are useful to link and trace test cases (e.g. KUnit) to
> > > > the different behavior IDs and define the constraints to be
> > > > met by the function's caller.
> > > >
> > > > Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> > > > ---
> > > >  Documentation/doc-guide/kernel-doc.rst | 19 +++++++++++++++++++
> > > >  1 file changed, 19 insertions(+)
> > > >
> > > > diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation=
/doc-guide/kernel-doc.rst
> > > > index 8d2c09fb36e4..23e6c4b45b14 100644
> > > > --- a/Documentation/doc-guide/kernel-doc.rst
> > > > +++ b/Documentation/doc-guide/kernel-doc.rst
> > > > @@ -83,6 +83,25 @@ The general format of a function and function-li=
ke macro kernel-doc comment is::
> > > >     *
> > > >     * The longer description may have multiple paragraphs.
> > > >     *
> > > > +   * When specifying testable code behaviour the longer descriptio=
n must contain
> > > > +   * a paragraph formatted as follows:
> > > > +   *
> > > > +   * function_name behavior:
> > > > +   * [ID1] - [expected behavior]
> > > > +   *
> > > > +   * [ID2] - [expected behavior]
> > > > +   *
> > > > +   * [...]
> > > > +   *
> > > > +   * [IDn] - [expected behavior]
> > > > +   *
> > > > +   * function_name constraints of use:
> > > > +   * [ID1] - [constraint to be met by the caller]
> > > > +   *
> > > > +   * [ID2] - [constraint to be met by the caller]
> > > > +   *
> > > > +   * [IDn] - [constraint to be met by the caller]
> > >
> > > So the same "id" is used for a behavior, AND a constraint?
> >
> > The idea is to have a specific behaviour or constraint of use
> > identified by the tuple [function_name behavior][ID].
> > So I think we could have a problem for duplicated symbols (but
> > it is a sort of corner case...)
>
> I am trying to say that you have ID1 listed in two places above.  So
> that's not unique with a [function_name][ID] pair, where does the
> "behavior" part come in?

Maybe it is not clear from the patch above (and I can find a better way
to describe it), however if we take one example from patch 2 we have:

[...]
+ * read_mem behavior:
+ * 1. it checks if the requested physical memory range [ppos, ppos + count=
 - 1]
+ *    is valid;
+ * 2. for each page in the requested range, it checks if user space access=
 is
+ *    allowed;
[...]

So in the end a unique identifier is "[read_mem behavior] [1]" and if the s=
ame
IDx is used for both behavior and constraint there would be no issues since
the tuple is the actual unique identifier.
So for example in partch 2 we have:
[...]
+ * memory_open behavior:
+ * 1. This function retrieves the minor number associated with the input i=
node
+ *    and the memory device corresponding to such a minor number;
[...]
+ * memory_open constraints of use:
+ * 1. The input inode and filp are expected to be valid.
[...]

In this case while 1 is used as IDx for both the behavior and a
constraint of use
the is no ambiguity since the unique identifiers are "[memory_open behavior=
][1]"
and "[memory_open constraints of use][1]"

>
> What is now parsing these comments to ensure that they are unique, in
> correct order, and are used elsewhere?  What is the text for such a
> behavior and constraint?

Right now I have not implemented any check to make sure the identifiers (in
terms of tuples as explained above) are correct and unique, however maybe
a check can be added in kdoc_parser.py to make sure no duplicate tuples exi=
st
in the same file (I guess that we do not need to check tuples uniqueness ac=
ross
multiple files)

>
> Heck, what does a "constraint" mean?

A constraint to be met by the caller of the function (e.g. passing a
valid pointer
when the function is missing checks on the validity of it, invoking a funct=
ion
with a certain mutex locked, avoiding certain ranges of input parameters )

>
> > > And what defines an "id"?  I see in your example you use number.numbe=
r,
> > > but is that specified?
> >
> > I thought that there is no need to specify an ID format as long as the =
ID is
> > unique and referenced by the kunit tests testing the symbol.
> > Basically I thought that in some cases it is easier to enumerate 1, 2, =
3,
> > whereas in others a, b, c can be used or even a mix 1a, 1b, 2a, 2b etc.
> > So I wanted to leave such freedom to the programmer.
>
> Ok, so be aware that people will then put whatever they want in there,
> making it impossible for you to parse :(

Once we have a check on the uniqueness of the tuples within a single
file, we can add another check when building kunit tests that look-up
identifiers documented in the test headers to match the tuples from the
source code being tested.

So for example in patch 5 we have:
[...]
+/**
+ * read_mem_zero_count_test - Verify behavior when @count is 0
+ * @test: KUnit test context.
+ *
+ * Confirms that read_mem() correctly handles a zero-length read.
+ * Per POSIX semantics, this may either return 0 or return an error
+ * if parameter validation is performed.
+ *
+ * Expected test behavior:
+ *  - the input @buf user space buffer is not written;
+ *  - @ppos is not modified;
+ *  - 0 or -EFAULT is returned.
+ *
+ * Tested behavior:
+ * [read_mem.1]
+ */
[...]
This means that this test is testing "[read_mem behavior] [1]".
Having said that, technically this policy allows for very human unfriendly
itemized lists, but I hope developers' common sense and the maintainers'
judgement to be sufficient for this not to happen.

>
> > > And how is a id going to stay in sync across different files?  That
> > > feels impossible to maintain for any length of time, and puts a burde=
n
> > > on the developer who wishes to add/remove a test or "id", AND a
> > > maintainer who has to remember to go and look in multiple places for
> > > such an id sync up.
> >
> > Well given that the tested ids are defined by the tuples mentioned abov=
e,
> > the relation between a kunit test and the tested tuples should be not
> > ambiguous.
>
> How do I "know" that there is a test that matches the tuple at all?

As mentioned above the test cases descriptors define the tuples that
are tested. So using a tool like BASIL or StrictDoc it is possible to
generate a graph tracing tests to the corresponding tuples

> Your patch series proves this, it adds the tuple in one, and then the
> test in another.  If you add another patch that adds another comment,
> how do I as a maintainer know if this refers to an existing test, or a
> new one somewhere else?

I would say
- If the patch is modifying the text of an existing tuple the maintainer
would directly see it and, by using a traceability tool, he would know
the impacted tests
- if the patch is adding a new tuple by definition it is a new behavior
or constraints (so the gap will be identified by the lack of tests tracing
to it)
- if the patch adds a comment that is outside the list of tuples, such a
change must be reviewed by the maintainer to figure out if the comment
is appropriate as an informative note or if instead should be part of eithe=
r
lists (probably if there is also a code change it is more likely that the
behaviors and constraints of use must be updated)

>
> > Also I thought that, when writing a kunit test, the tester should know =
which
> > behavior is being tested and hence it should be easy to define the test=
ed
> > tuples in the kunit header.
> > So I do not see much of a burden, but maybe I am missing something here=
...
>
> if there is no automatic way of linking a comment to a test, the ids
> WILL get out of sync.  We have 20+ years of history for "simple" things
> like enums and strings getting out of sync in the same exact file.
> Whenever you are going to allow a free-form structure like this, and yet
> expect a maintainer and developer to always know how to keep it in sync,
> that's just an impossible task, please do not do that.

Got it, so I wonder if the extra checks I mentioned above WRT kdoc_parser.p=
y
and the kunit build process together with the traceability tool (BASIL
or StrictDoc or
others) would help to address this issue...

>
> And let's go back to the root issue, why have an id at all?  Who
> benefits from this?  Who requires it?  Who wants it?  Who will do the
> work to add/maintain/update them all?

Ok, here I assume that we agree on the value of having function specificati=
ons
and kunit tests.
So I guess that the key question is why adding traceability provides value.
To this point traceability makes it easier to understand the test cases aga=
inst
specifications, allows to spot specifications that are lacking tests and al=
lows
to easily spot tests that require modifications following a
specifications' update.

If you do not see value in traceability for /dev/mem I can drop patch 1 and
just re-submit using simple bullets and removing the tuples references from
the kunit tests, otherwise I could work on the implementation of the checke=
rs
mentioned above when building kernel-doc and kunits so that it would be
easier for a maintainer to manage such a traceability....

Thanks and regards
Gab

>
> thanks,
>
> greg k-h
>

On Thu, Feb 12, 2026 at 4:23=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Feb 12, 2026 at 03:00:01PM +0100, Gabriele Paoloni wrote:
> > On Thu, Feb 12, 2026 at 1:59=E2=80=AFPM Greg KH <gregkh@linuxfoundation=
.org> wrote:
> > >
> > > On Thu, Feb 12, 2026 at 01:49:18PM +0100, Gabriele Paoloni wrote:
> > > > Extend the longer description section of a function kernel-doc
> > > > header with an itemised list of function's behaviors and
> > > > constraints of use.
> > > > These are useful to link and trace test cases (e.g. KUnit) to
> > > > the different behavior IDs and define the constraints to be
> > > > met by the function's caller.
> > > >
> > > > Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> > > > ---
> > > >  Documentation/doc-guide/kernel-doc.rst | 19 +++++++++++++++++++
> > > >  1 file changed, 19 insertions(+)
> > > >
> > > > diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation=
/doc-guide/kernel-doc.rst
> > > > index 8d2c09fb36e4..23e6c4b45b14 100644
> > > > --- a/Documentation/doc-guide/kernel-doc.rst
> > > > +++ b/Documentation/doc-guide/kernel-doc.rst
> > > > @@ -83,6 +83,25 @@ The general format of a function and function-li=
ke macro kernel-doc comment is::
> > > >     *
> > > >     * The longer description may have multiple paragraphs.
> > > >     *
> > > > +   * When specifying testable code behaviour the longer descriptio=
n must contain
> > > > +   * a paragraph formatted as follows:
> > > > +   *
> > > > +   * function_name behavior:
> > > > +   * [ID1] - [expected behavior]
> > > > +   *
> > > > +   * [ID2] - [expected behavior]
> > > > +   *
> > > > +   * [...]
> > > > +   *
> > > > +   * [IDn] - [expected behavior]
> > > > +   *
> > > > +   * function_name constraints of use:
> > > > +   * [ID1] - [constraint to be met by the caller]
> > > > +   *
> > > > +   * [ID2] - [constraint to be met by the caller]
> > > > +   *
> > > > +   * [IDn] - [constraint to be met by the caller]
> > >
> > > So the same "id" is used for a behavior, AND a constraint?
> >
> > The idea is to have a specific behaviour or constraint of use
> > identified by the tuple [function_name behavior][ID].
> > So I think we could have a problem for duplicated symbols (but
> > it is a sort of corner case...)
>
> I am trying to say that you have ID1 listed in two places above.  So
> that's not unique with a [function_name][ID] pair, where does the
> "behavior" part come in?
>
> What is now parsing these comments to ensure that they are unique, in
> correct order, and are used elsewhere?  What is the text for such a
> behavior and constraint?
>
> Heck, what does a "constraint" mean?
>
> > > And what defines an "id"?  I see in your example you use number.numbe=
r,
> > > but is that specified?
> >
> > I thought that there is no need to specify an ID format as long as the =
ID is
> > unique and referenced by the kunit tests testing the symbol.
> > Basically I thought that in some cases it is easier to enumerate 1, 2, =
3,
> > whereas in others a, b, c can be used or even a mix 1a, 1b, 2a, 2b etc.
> > So I wanted to leave such freedom to the programmer.
>
> Ok, so be aware that people will then put whatever they want in there,
> making it impossible for you to parse :(
>
> > > And how is a id going to stay in sync across different files?  That
> > > feels impossible to maintain for any length of time, and puts a burde=
n
> > > on the developer who wishes to add/remove a test or "id", AND a
> > > maintainer who has to remember to go and look in multiple places for
> > > such an id sync up.
> >
> > Well given that the tested ids are defined by the tuples mentioned abov=
e,
> > the relation between a kunit test and the tested tuples should be not
> > ambiguous.
>
> How do I "know" that there is a test that matches the tuple at all?
> Your patch series proves this, it adds the tuple in one, and then the
> test in another.  If you add another patch that adds another comment,
> how do I as a maintainer know if this refers to an existing test, or a
> new one somewhere else?
>
> > Also I thought that, when writing a kunit test, the tester should know =
which
> > behavior is being tested and hence it should be easy to define the test=
ed
> > tuples in the kunit header.
> > So I do not see much of a burden, but maybe I am missing something here=
...
>
> if there is no automatic way of linking a comment to a test, the ids
> WILL get out of sync.  We have 20+ years of history for "simple" things
> like enums and strings getting out of sync in the same exact file.
> Whenever you are going to allow a free-form structure like this, and yet
> expect a maintainer and developer to always know how to keep it in sync,
> that's just an impossible task, please do not do that.
>
> And let's go back to the root issue, why have an id at all?  Who
> benefits from this?  Who requires it?  Who wants it?  Who will do the
> work to add/maintain/update them all?
>
> thanks,
>
> greg k-h
>


