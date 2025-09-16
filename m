Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65670CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 07:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FDF8E0011; Tue, 16 Sep 2025 03:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29208E0001; Tue, 16 Sep 2025 03:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0768E0011; Tue, 16 Sep 2025 03:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 883088E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:29:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1391FC0510
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:29:13 +0000 (UTC)
X-FDA: 83894287386.03.F993D16
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE6C640006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:29:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=wolber.net header.s=fm3 header.b=DMEj0aja;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="n Bon4aO";
	spf=pass (imf07.hostedemail.com: domain of chuck@wolber.net designates 103.168.172.156 as permitted sender) smtp.mailfrom=chuck@wolber.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758007751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dG0DMsEGkyA0BzrklEyus+igoCRBk/3dmQ9mxYJ0v8=;
	b=uG6ezZ28LQDztWPBwhhze5Q3etFtPKcwiS5EV1PJ1tp9VRVfawKer9HAXU16U6CMZ8Nv2k
	SEVIkbnoL/D2Qow4RxYetv0B42UkzuTxa5dT11NEVr1EwtDeIlLIs/RWlQBHAhflEptPzR
	gryK9rZD4ao6fH2JRQM+2ErV/LYmFL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758007751; a=rsa-sha256;
	cv=none;
	b=heW7fgLweFcrYFEG9yJ7zuip8enfLzMmuF9W/r63bSWHdmPVxHzV8xXL0Hy3Dc1+i6aB2J
	/eqw0F1AEGLwvkgc20a9+bxCObjJXLd3DNbZfEfLFZXwLGWR1Mr1oUmBmYVg8V1rKNpIfJ
	mOIkoAmqMq5cNemnWUW7alwK6LC9ddw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=wolber.net header.s=fm3 header.b=DMEj0aja;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="n Bon4aO";
	spf=pass (imf07.hostedemail.com: domain of chuck@wolber.net designates 103.168.172.156 as permitted sender) smtp.mailfrom=chuck@wolber.net;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 283BC140026A;
	Tue, 16 Sep 2025 03:29:10 -0400 (EDT)
Received: from phl-imap-03 ([10.202.2.93])
  by phl-compute-02.internal (MEProxy); Tue, 16 Sep 2025 03:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolber.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1758007750;
	 x=1758094150; bh=0dG0DMsEGkyA0BzrklEyus+igoCRBk/3dmQ9mxYJ0v8=; b=
	DMEj0aja9nt1pRxz2uOZdbZ0O6VlvxQ9UVj1Hab40BG30flvr/K5R5l3h1lDl/2S
	Mw5eJBwdhZqrdYAMgaO7IXiSbD/Mp1yhLrwEaQ0C1FV/E9Ko/e/dLE2jkdUE41Ir
	Krqg/AgPnhWjAH5CEnwjLOOq9GD0vsf6Mz9Wv2dk7xWv0EZ5v7u5Q+aOjOOm4CWT
	J6kgvQ/KZjYwtC1vCo8Be5UrxcCA1/6wJGNGp7wmkL70SEo2xqXVjISUhUTD2YQ/
	B04hf76elxyBcsiL1P1BqZwnWakUHPf6eysgQ03hlRzcwv6izTXLR6miM2O7aCOV
	8FpTysctmorHnvKqFokJ9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758007750; x=
	1758094150; bh=0dG0DMsEGkyA0BzrklEyus+igoCRBk/3dmQ9mxYJ0v8=; b=n
	Bon4aOM29Sk8Ta7RAanKX5YYuWFgARybA+fUnCDE8+lEQx0kisCoIF+HuXiTkzYP
	xvgkPknqhMDSkqkCCc94W78F0j+MWUZmU+luuuZgMnDebYOQybkttFMNTRvGEiMk
	tCl91JqyMZOw4Mjq1gsuicyw3eyX+DL7KUxTIRExokwVdvsJ2bYvazZXdOc14XQW
	gj4zf5ae7CyO07kKqXRjFCkOXelU8KzyS/xf0b0VjgCKn6dWwijkmyNEe0J0JGit
	ny2JD1nR1GFXLIIRJLEHYp6LnZHTy+OPtb089KDIaFnx+IVN5DR9p7qoWKSool83
	riMmEDqGzhSka5ge9Vdhg==
X-ME-Sender: <xms:xRHJaFKOxFkC4WXPNMFI-v83qD2O7hoYPCItKIFMizGM2BMYtE4MTg>
    <xme:xRHJaBJhHGizG_gS2dWWzyzZKTBBpEGIIPCwV4yZ3OshaCp0sWciftMSOrXiDWQDp
    iSwKKENboTJHJ7_5w4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdefleeljecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggfgtgffkfevuffhvffofhgjsehtqhertdertdejnecuhfhrohhmpedfvehhuhgt
    khcuhgholhgsvghrfdcuoegthhhutghkseifohhlsggvrhdrnhgvtheqnecuggftrfgrth
    htvghrnhepgefhieelvdfgvedvfffgudehueeukefgfeefhfeiudejieevheekgffhtddt
    udetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptg
    hhuhgtkhesfiholhgsvghrrdhnvghtpdhnsggprhgtphhtthhopedugedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheptghhuhgtkhifohhlsggvrhesghhmrghilhdrtghomh
    dprhgtphhtthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhrtghpthhtohep
    shhhuhgrhheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvh
    grtghkrdhorhhgpdhrtghpthhtohepghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhi
    ohhnrdhorhhgpdhrtghpthhtohepkhhsthgvfigrrhhtsehlihhnuhigfhhouhhnuggrth
    hiohhnrdhorhhgpdhrtghpthhtohepshgrfhgvthihqdgrrhgthhhithgvtghtuhhrvges
    lhhishhtshdrvghlihhsrgdrthgvtghhpdhrtghpthhtoheptghorhgsvghtsehlfihnrd
    hnvghtpdhrtghpthhtoheprggtrghrmhhinhgrsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:xRHJaHfmI42uPyXLmOkj0hO0DDvl5OpK8gQI-KvQBuQSt4nluqtQPg>
    <xmx:xRHJaJCq0q1vz7Z1Txvn0ukmu8tOwILxUPFjS-2iFoBxw4SK-LdcDw>
    <xmx:xRHJaG8jF4Bm9oHjY2s0DzoBflD93LK7Bvssugr7qlMUxnNQbVhGmg>
    <xmx:xRHJaFrVLtTwanWydR6KUlFMXH2HHTpid37-2MUvB31jZHHLiYEO0g>
    <xmx:xhHJaJ5qhSGMfkUkz8LX3TuX1rrq44XZf-Uq3pL5HrBDoKq7C_LBGddB>
Feedback-ID: i5cf64821:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9D64C18E0069; Tue, 16 Sep 2025 03:29:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Sep 2025 07:29:08 +0000
Message-Id: <DCU1QIJH8II0.17CHTYNIW9WSK@wolber.net>
Cc: <linux-mm@kvack.org>, <safety-architecture@lists.elisa.tech>,
 <acarmina@redhat.com>, <kstewart@linuxfoundation.org>,
 <chuckwolber@gmail.com>, <chuck@wolber.net>, <rostedt@goodmis.org>
Subject: Re: [RFC v2 PATCH 2/3] /dev/mem: Add initial documentation of
 memory_open() and mem_fops
From: "Chuck Wolber" <chuck@wolber.net>
To: "Jonathan Corbet" <corbet@lwn.net>, "Gabriele Paoloni"
 <gpaoloni@redhat.com>, <shuah@kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <gregkh@linuxfoundation.org>
X-Mailer: aerc 0.21.0
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <20250910170000.6475-3-gpaoloni@redhat.com> <874it3gx2q.fsf@trenco.lwn.net>
In-Reply-To: <874it3gx2q.fsf@trenco.lwn.net>
X-Stat-Signature: wt86dios3popfwgkmcfx647hw7x4ktsb
X-Rspam-User: 
X-Rspamd-Queue-Id: DE6C640006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758007750-790356
X-HE-Meta: U2FsdGVkX1+CuyuZcaJ77RtqPWLkZpuvigS1JwIzPZKlaxqx13a229gR0LWVrvqErvRMb77arLC/YePGeapJv0SQ0YXN9pfH5t21QASZz8oz0as0Kvwivgifg6JSnHkeQ7jrFIHjTG5ADqMzlH2U6RIKe8KS93sH67IuJYHrvHQBlDNy52vkZRy+VvHtMRKTZKYmjWE+of028p3OhORWJDipODtVpT+Oi2qt+PdEFbC3PDNisOHSCejCUnHdP+60+5YhA8Z3Ys23qIz+8OvQnWMiqeT+28yKLICK2Bwmyq/IDIMSykydnUmtsWmM+m15dU9e/F55qK/w0B5fLvO1jg546q0U+WAE22soN4VDOA6xKMU4eNtMkMznIqtJQ43/B5sTk9ggw8B9Uz3tnNBYQLfOBJYAh1F1K2qJt93oyefrIvWcRET98h6bMfT987rqXo1UGdDiblTeTf7svhdbPA8qaEC+bGzSuJLC+iovLa6e6olVwY/ZeDCDaGTL5j7zU23C6IpnikE7dr6fDIvXAbSQtj5+65iacEPRik5KCDm2PQJseciYTVejy84jv3fl+mSpntU3mdk4qNgbumOelCov8TGGb3+YfEQ+TsKuq9MixGgdERZQywHmyjjBJhn8AikzySO3P7t4H1TO2MfS/07gOKQxHC4FshnIvCTG7a1+SoW7dQ6XtfpqtzEqc3dVR7/1CN0t54Mi+RwFbwPR5IHV2elNaYT0TIx5Bpa/AvX1CCnjgSy1nGDkOkAgtlsS4c8oTnPZCzzT7PLvImEJMb7PSJ+/wa3HxvhOFZybTbX/D7/vPYX0Ylf9iSbx2X1OjmUDMyCGwIAwDKXnxBpwyiw3gUcj4aFn4NW1cCCQR60/fg9tFhD3RmPU/5YKC1JnSzZET+lSvQFPpXKTx4UyjhnHNIV3QxqnhSKUPrwy0DJF1XFQVbqGTIev3t6ZB5NII2z6eTB/QrBnwXMWbMS
 w17bOMVF
 4LQ9ADWlXVZbhkKBYom962EAKgzpTkAMfLougDt1HXm4SqjzCnI7+yL6bNeNgg006vyJ2yXjj+8xbmaCox0Kkq/LRpQbUObXAcUE1NeNOwVYHP3PaTO8f2LmqBjpyodyAqUJJJlEA+K4SXO+27Esm32n4vXahlg+FCUqOPkZ0B48Gch81GnJ8SCzkJNDz5lsgfupXdyKPqq0V+0t/BZEvL+oZwTMvYp6BVfIwCi44d7sifUxg8GBKEV820k+n5YXsd+NNki1AJJlfv2dLUr4Gf10S1xoC6lLTHPK0tycs/ZTdRKpr+ydN1qZ0XjK4jOIqm5WC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 15, 2025 at 10:39 PM UTC, Jonathan Corbet wrote:
> Gabriele Paoloni <gpaoloni@redhat.com> writes:
>
>> This patch proposes initial kernel-doc documentation for memory_open() a=
nd
>> most of the functions in the mem_fops structure.  The format used for th=
e
>> specifications follows the guidelines defined in
>> Documentation/doc-guide/code-specifications.rst
>
> I'll repeat my obnoxious question from the first patch: what does that bu=
y
> for us?

Fair question, and definitely not obnoxious.

It might help to reframe this a bit. The idea is to take an engineering
technique from one domain and apply it with modifications to another. The
relevant terms of art are "forward engineering" and "reverse engineering".


> My kneejerk first reaction is: you are repeating the code of the function=
 in
> a different language.

No disagreement on that perception. We have more work to do when it comes t=
o
communicating the idea, as well as developing a better implementation.

The design of the Linux kernel is emergent and, in the present state, all f=
orms
of testing are an (educated) guess at the intended design. We can demonstra=
te
this by picking a random bit of code from the kernel and assigning ourselve=
s
the task of writing a test for it.

Are you certain that your test accurately reflects the true design intent? =
You
can read the code and test what you see. But that does not mean that your t=
est
is valid against the intent in someone else's head.

Music instructors see this whenever their students play the right notes but
clearly do not yet "feel" the music. The difference is noticeable even by
casual listeners.


> If we are not convinced that the code is correct, how can we be more
> confident that this set of specifications is correct?

We have no reason to be independently convinced of either. When we describe
this as importing a technique into a new domain, your question is an exampl=
e of
some of the concessions that have to be made.

The Linux kernel is not a forward engineered system. Therefore it is not
possible to develop code and test from the same seed. Our only option is to
reverse engineer that seed to the best of our abilities.

At that point we have a few options.

Ideally, the original developer can weigh in and validate that our
interpretation is correct. This has the effect of "simulating" a forward
engineering scenario, because a test can be created from the validated seed=
 (I
am trying valiantly to avoid using the word kernel).

Absent the original developer's validation, we have the option of simply
asserting the specification. This is equivalent to the way testing is done
today, except a test can be equally opaque with respect to what design it i=
s
attempting to validate.

In either case, if a test is developed against the specification, even an
initially incorrect specification, we have the ability to bring code,
specification, and test into alignment over time.


> And again, what will consume this text?

Humans are the consumer. But to be clear - a machine readable template is g=
oing
to be required in the long run to ensure that code and specification remain
aligned. Our intentent was to avoid confusing things with templates, and
introduce them once we have made headway on the points you have brought up.

It is probably also worth mentioning, we have already had an "a-ha" moment =
from
one kernel maintainer. I believe the words were something to the effect of,
"this is great, I used to have to relearn that code every time I touch it".


> How does going through this effort get us to a better kernel?

I am hoping some of the above planted the seed to answer this one. Code mus=
t
be correct in two ways, it must be valid and it must be verified.

Valid means - the code is doing the right thing.
Verified means - the code is doing the thing right.

If code and test accurately reflect the same idea, then we can alleviate
maintainers of a large portion of the verification burden. Validation is in=
 the
"hearts and minds" of the users, so that burden never goes away.


> Despite having been to a couple of your talks, I'm not fully understandin=
g
> how this comes together; people who haven't been to the talks are not goi=
ng
> to have an easier time getting the full picture.

I agree. And thank you very much for attending those talks and engaging wit=
h
us. It truly means a lot.

I have submitted a refereed talk to this year's Pumbers conference that is
intended to go over these points in detail. My colleague (not on this threa=
d)
has also submitted a refereed talk on best practices for developing these
specifications. His name is Matthew Whitehead and he is a recognized expert=
 in
that area.

..Ch:W..


