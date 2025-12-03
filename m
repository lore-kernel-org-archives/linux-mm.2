Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AD2D1268E
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 01:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13BD86B0012; Tue,  2 Dec 2025 20:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1136F6B0024; Tue,  2 Dec 2025 20:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0025C6B0027; Tue,  2 Dec 2025 20:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E397F6B0012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:47:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9103B131FBC
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:47:09 +0000 (UTC)
X-FDA: 84176471778.12.46213E4
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B8B88000B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:47:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M++JjPRI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764726427; a=rsa-sha256;
	cv=none;
	b=bfxHV314q43dkScOu/fsIa3fg6qRTDwaKB1Mj/zR8ry4g4u1oRk+Alf/gDJMwvqFsXMMxU
	6on9Y4RFtZMY6N1VjPdfPVUMIW4PYdgEfN96YTMRDr3MX0oIR0EUDVsfax+9fKYIvKWBNO
	ZzQ5nANXBX5sPuDhw//tzmtkYOCAG2s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M++JjPRI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764726427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtH1a85NzPXIElQyhEPKVrfDvnNRb+rvBUgIUrut7Kw=;
	b=w8DYJUWUpc5PxOxEowNnuLiK9kzuUCfniBPLbCOL7O/OIhahoy2ySRPlvMKVx7JKAeyBWM
	AQvZ28tFo7dSNUIMJrTh1OchtXsO7Yb3e2xMurcT7E617dArvKbtRAAy1WUTE4y1p/ub6x
	btKmX9m3pHnIqDPqu4r2ratYaPFCvxA=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b144ec3aa8so572196885a.2
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 17:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764726426; x=1765331226; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OtH1a85NzPXIElQyhEPKVrfDvnNRb+rvBUgIUrut7Kw=;
        b=M++JjPRI76mKGdK1j6jfsGkE8BplXDnS3x/V+RtK9Of8yOf3GYagN8NTRGyKi5C1aH
         M8C0Jf3P8ea9eUU6vJz3U4oR++5IecRCKdRct6NSmGrwSvYPU9d75nh5atvXABn+sTQB
         L4ZgRaRS5V/1Hj7hTCbJ09aLeE0ypHwaRMNEhpbgbxS+VsD3OhkTwf4AJrD4l9Hmoy6H
         5AuivDd1loWRH4mAG50zLnpSJpcJYvRNAYo9MGNJMDGS6CvlLneHIEn66PXsu8vp2UiH
         3VKXItqf2VChvWsApInAlDcOKrbcEDSIFNylRMV9OpKuyOVfbz9LpQm3yn+NfupY33KR
         R5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764726426; x=1765331226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OtH1a85NzPXIElQyhEPKVrfDvnNRb+rvBUgIUrut7Kw=;
        b=pUgrHk4YVpk0Fi6Alk4OadGMb+oEjFG1+vitwR6Gf2oH/qdoNPyuVMKOqQ5GHG/RBv
         1o4FhQggkXOJR1z/Mo0qsFJAUd0T7mlARSypCfGf4M7Obs6MTtQEpg06iTEQ56uYgul3
         tyxPQPvHDGhNR2XYgaOHEawySVdSUspvIrNrQQ9dYPK5gYjkPnCMDRYeM5hX519NLJPm
         Rz14Y957HjTfFbuT8HtdUp1J4Wav1w91KbaT0BU8FVPHZ3dKfj63wzSuM2hpPlvcjtr6
         tBaDxF7OpNF5WuOuw0OmVzL+a4NmmwP7y9eJzPpuc/wG56zTRFnVpDd4l2TZYkgceny1
         cScg==
X-Forwarded-Encrypted: i=1; AJvYcCWi33uuDIiQP6CxUnaAJ7q3Ps5hzXaRZ80X9ltaWdemn48pFIlJ2Q2uzsbGmyPTTPFOwTKju3VNvA==@kvack.org
X-Gm-Message-State: AOJu0YxzohFaI/Udp6JjkVKNDX6ub0UEOQzHGsq6w/smxbd/aROH0ud0
	DvwXh2eVaSGE8i917XkY5/+CxaLF70weTL06ngXStB4OoijsO3LvVz4Loc9Rng==
X-Gm-Gg: ASbGncsUOqXo3fsi5pbIgrHE8myJptcXhZjdw32IF7Sa+a3ruqpul2h/naiUQzMSvxT
	B3ZIXDTU5TaTYLbJepaLTTPgHKfYkOXsu01OEqKbwhLy498/AnDM0k2DtBVqXJoM7epXYy22RnD
	I3pKmDk+bXJXc9Qu6vjBwB+nOhht6vmWyJga30+54QkYatFl9Us0vc1PKvAm9ah2tq+30FXPkSm
	8gp3vka/QAv5QzP9ezKL5UYCe1tRkuwnOX1g6CdVwjRXspD+L28WLhPl+MTMgP3t0ycQDWrCHCv
	wd+WQ+ORX5Ky5zu+lVuXfLevZksOB/NHiZte96f1VQtAFoNbQCr+XU7Zs1wMm2AW3FY46FH0mWL
	sq/ndpz3QkzKN1SwkdTcyjsxEiPH6iyQMzKQVJtkqjNQeGZ7WUMwyzeUct/4Rf59dz/+NdHrh3E
	EzbJ0FyAa7wshQOWk020klJgidGLbsxn6Or2AZdeOzhg2Z7KluJWDdzDL5PakWf/tpFzbGc8Yru
	b85NrhouvbDox5JukZcW6qbhw==
X-Google-Smtp-Source: AGHT+IFeMR+oSVn09EJ3IDZOwhh2uiS4UVZ0hp1HU+YMpxzfU9ogbzDHH3W62a3tJUAdySWBH37uAw==
X-Received: by 2002:a05:620a:2805:b0:8b2:d56a:f2f1 with SMTP id af79cd13be357-8b5e47cfdaamr99382185a.12.1764726426099;
        Tue, 02 Dec 2025 17:47:06 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524b1aa6sm119441246d6.8.2025.12.02.17.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 17:47:05 -0800 (PST)
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id ACD9EF40079;
	Tue,  2 Dec 2025 20:47:04 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 02 Dec 2025 20:47:04 -0500
X-ME-Sender: <xms:mJYvaaDmnK-eQoA_EF5dIKBTmJFKJG6JnnoegiOnZKVT8CNUG_YZFg>
    <xme:mJYvadSJ45vWYeQ9F5mL5h1nMVY-8bU-OaEP6MA5NELkAMhxMnC3oTCpPE77lCBHK
    7T7DCcgyxDTJotNCxAXaXhpptJ3QWP-MaGb6ZrIeVNqxosuK0JF82c>
X-ME-Received: <xmr:mJYvafxcm6YlRM-vftTxYa0HsgC9YSewKe3-7hU6gkHJFIR9j-dqDET8mDz9W_yI4jfLTFLmfy4EJaHEsee2Ieq8FtBpB-e8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcuhfgv
    nhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrh
    hnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueevieduffeivden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquh
    hnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudej
    jeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrd
    hnrghmvgdpnhgspghrtghpthhtohepkedupdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehruhhsth
    dqfhhorhdqlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegu
    rghvihgurdhmrdgvrhhtmhgrnhesihhnthgvlhdrtghomhdprhgtphhtthhopehirhgrrd
    ifvghinhihsehinhhtvghlrdgtohhmpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehpvghtvghriiesihhnfhhrrgguvggrugdrohhrghdprhgtph
    htthhopegvlhhlvgesfigvrghthhgvrhgvugdqshhtvggvlhdruggvvh
X-ME-Proxy: <xmx:mJYvafm1w4VDhZtfL-vbtABRjhTNIcFLz8_RoOmFJXiaSOHOJFRUsA>
    <xmx:mJYvaTW4xPwqaL8AsLZ0eWuclQx3vE9Zqhyto1-mcNhBpI554zsuvg>
    <xmx:mJYvaXX2hT3SDveYJ-poTdQsJ8M2nsxtzyvAAaEGn-Ah6ycumKDy0w>
    <xmx:mJYvaS9D9MkMxArS_FuKXUpeU0lMFKOAD8JwuBHAD4qUAR-XYoc_nw>
    <xmx:mJYvaaBq2FcntQ00GFur5OcCdB2TqHkbOovvZlruCm-nWJGwWixyD_zx>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 2 Dec 2025 20:47:03 -0500 (EST)
Date: Tue, 2 Dec 2025 17:47:03 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dave Ertman <david.m.ertman@intel.com>,	Ira Weiny <ira.weiny@intel.com>,
 Leon Romanovsky <leon@kernel.org>,	Peter Zijlstra <peterz@infradead.org>,
	Elle Rhumsaa <elle@weathered-steel.dev>,
	Carlos Llamas <cmllamas@google.com>,	Yury Norov <yury.norov@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,	linux-block@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org,
	Benno Lossin <lossin@kernel.org>,	Danilo Krummrich <dakr@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>,
	linux-security-module@vger.kernel.org,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Lyude Paul <lyude@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
	Jason Baron <jbaron@akamai.com>,	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	linux-kselftest@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vitaly Wool <vitaly.wool@konsulko.se>,	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>, devicetree@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Krzysztof =?iso-8859-1?Q?Wilczy=B4nski?= <kwilczynski@kernel.org>,
	linux-pci@vger.kernel.org, Remo Senekowitsch <remo@buenzli.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org,
	Will Deacon <will@kernel.org>, Fiona Behrens <me@kloenk.dev>,
	Gary Guo <gary@garyguo.net>, Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,	Alexandre Courbot <acourbot@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,	Ingo Molnar <mingo@redhat.com>,
 Waiman Long <longman@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	John Stultz <jstultz@google.com>, linux-usb@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Tamir Duberstein <tamird@gmail.com>
Subject: Re: [PATCH 00/46] Allow inlining C helpers into Rust when using LTO
Message-ID: <aS-WlwsvGrbGYIYs@tardis.local>
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B8B88000B
X-Stat-Signature: 4mc4g1x17eijtrghgo8cbukf4zous47h
X-Rspam-User: 
X-HE-Tag: 1764726427-716103
X-HE-Meta: U2FsdGVkX1/gafcLC3K6Aey10oOZBEEi/0vqVdlG3XiEB4Z3XiHiof2Inj27Sp27JW6V/V2cAyeyYmJr9ThQXstH40/TJ9hse2Fcw/gimP5mq9S3EnLUgZPJMCs0PFU0OoYWydmH8lxQqyzur0L7i/swI/nREwhVEZUCLyV1djOhiX0SQGuWuVTQFC2sGquDyCtTc/qpiiKL05dQUnsr1WQtam7tw25uE0SENut5sQN1KKDeADiIAxxjF7iPyIvMdlUZt6f/Vqal8fmrhpMbfDFWV6p6zxyRWgczvkqSamExu7vJK0+AnlkA1tM+SI+kfwedbg4rw3nn1kn97iCKMxpuGKw/Uyad9XxcYAXH/aw6trTA29ZTO2uzjF+Bl1zcXb5PcjSgih04721Ku17NZPQiHlqKOCspgP/9OJwMxGy6uj6Dh4aT/u70TMPynEsB4Z00DYngmSfoqJoWTJrc3cDWPTpHZdZn7cunCN7ROTU0ER0bDjP20mzBO0yNJnkUN1G6m3YBSrStAWGCVBySaD21bcF7rlwROEvRcSTaaIEXakkrOAuGT1JLjX1ocYNQTyWpWKMpiD/9zUmc2FL9fGIIz4LJ1A8rMshj7V5rYlZzOt+L7HEAw6I7amS09K32DZvTjkFJJs/0A5Vietzncp/1m8zK/F+rCmDfnFw9P+UBISIiMXy+VqlOnxm2Q7GqeasGn8bS4RgzZ/136vAjFV7+05WCIWsxuxgJsE4jmUH3j7styP2Zroqk7nvaN/a+c4pTmVqfVHzAqcXL1eS6HALg+7k6FA+QKsauKJnC0o+8IXk3SrHd0HPIfIRyd5JxT31BxV61e/kgCghbnNcEZ4+OwenfKIjmHq6CH+SKzlEzaMbuUk0kaINPw1r+e/ExUZkypBwVq/mnjNB6W9Qs9ewBUGsUQQBz+dia4FtaUh5AS9rPSBFf3nVnJTQs4dCO2fQtZ9t0MqjRPTh+qKQ
 /QOWMMBr
 hdBI4ULvqb5GyqtZkh6UVi1wwxmElz07WzXKM7VuZrlrNjSgrxZT6Ja0g4A++XjzkLjXZiJZTIshStDFf0mNgJ//NOB3PXzB3ilKF6f6xltYxHBQKrsZ7Bw627EkvIyKiDqqGh6fmJx9/5nPidKL4y80nQgfRYIr9SrKSxuq068DpzcyCxR1sYReOqJJ+H3zjoSrMxHTEuxM0y0wAPRhvmMdDLVH18L1hfr5Krsqc4O1v6sUHylr8/I4z2WXmlKiLXplUvpzs1voDg6f+Ql2M2XtfYgGoyGSZtHv1yGKF3T+tS53Nb4IkesIsirJ8jfE3AdeV1aRddH3ngUBTs6tMN27C4NVwU+A7YNA+DN5yHnWOzeWVIygZ8VChNr0KKnK7P98zXs/010Xx3vGf2ugtW5aTbPhH/fJNHu/xpxJhnRr5+Xfmrx7HBIKrVvq3hnf+lD0HJ6R+cioV2gyw5QmKeTR21mpJGvyiIjLEmXbLfw+KJbAma+8Kh73k1milS0TF3apb/4aFaTDB3ZU01+WSd/j8T3VZTDyk3QD713AwFloeoTYL3r4Ek7s6dAs+FOMNVLBT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 07:37:24PM +0000, Alice Ryhl wrote:
> This patch series adds __rust_helper to every single rust helper. The
> patches do not depend on each other, so maintainers please go ahead and
> pick up any patches relevant to your subsystem! Or provide your Acked-by
> so that Miguel can pick them up.
> 
> These changes were generated by adding __rust_helper and running
> ClangFormat. Unrelated formatting changes were removed manually.
> 
> Why is __rust_helper needed?
> ============================
> 
> Currently, C helpers cannot be inlined into Rust even when using LTO
> because LLVM detects slightly different options on the codegen units.
> 
> * LLVM doesn't want to inline functions compiled with
>   `-fno-delete-null-pointer-checks` with code compiled without. The C
>   CGUs all have this enabled and Rust CGUs don't. Inlining is okay since
>   this is one of the hardening features that does not change the ABI,
>   and we shouldn't have null pointer dereferences in these helpers.
> 
> * LLVM doesn't want to inline functions with different list of builtins. C
>   side has `-fno-builtin-wcslen`; `wcslen` is not a Rust builtin, so
>   they should be compatible, but LLVM does not perform inlining due to
>   attributes mismatch.
> 
> * clang and Rust doesn't have the exact target string. Clang generates
>   `+cmov,+cx8,+fxsr` but Rust doesn't enable them (in fact, Rust will
>   complain if `-Ctarget-feature=+cmov,+cx8,+fxsr` is used). x86-64
>   always enable these features, so they are in fact the same target
>   string, but LLVM doesn't understand this and so inlining is inhibited.
>   This can be bypassed with `--ignore-tti-inline-compatible`, but this
>   is a hidden option.
> 
> (This analysis was written by Gary Guo.)
> 
> How is this fixed?
> ==================
> 
> To fix this we need to add __always_inline to all helpers when compiling
> with LTO. However, it should not be added when running bindgen as
> bindgen will ignore functions marked inline. To achieve this, we are
> using a #define called __rust_helper that is defined differently
> depending on whether bindgen is running or not.
> 
> Note that __rust_helper is currently always #defined to nothing.
> Changing it to __always_inline will happen separately in another patch
> series.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

For the whole series:

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
[...]

