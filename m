Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4669DCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0AB48E0005; Tue, 11 Nov 2025 08:13:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BAA58E0002; Tue, 11 Nov 2025 08:13:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A97D8E0005; Tue, 11 Nov 2025 08:13:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73CBD8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:13:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C308596E7
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:13:07 +0000 (UTC)
X-FDA: 84098366814.24.28493A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2A0B0C000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:13:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EYC0cbJ9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762866785; a=rsa-sha256;
	cv=none;
	b=4oNmOHCOofKxQnRGXUp6RX68xfMCcmAmXBtvXMwYgiQuLYz77A2NojpHqdbUaUnsX7xuOf
	g3c9ZsUSP8IiadEISnoFYOLR8cjFl0fGbsX3l9v0svP/VZx+9gDkLtvKQg6bqeRkodFB0X
	av3mAQCkCGr4zCYPz3gVgfa5Zfi3kN4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EYC0cbJ9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762866785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQiYZa+UMJ28kPPzr7A5LUc/D3pE1z5z0fBFkzoygMc=;
	b=Gmzt87QE/Ija7v6ynAaVR0zWs2IF8m3Yb19ydrk6WcyQPp5YnTuYTKNlg9Z8G70Op9OTXv
	OgBpl2kEANAqpd+wq2/YqgWcNQV+W18idSbyaT12cFJ+KpPLHQH/nDQCPV+2yniLBsW2eE
	/H7V5qDavKAjF2TxckVNnA7+KagLIkw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762866784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQiYZa+UMJ28kPPzr7A5LUc/D3pE1z5z0fBFkzoygMc=;
	b=EYC0cbJ99ssLpn2uk75zQfV+zZG40T4gEqBu9rm5xJZvXfyWza7kuGf5pA9Ysg1Vef/Uyn
	+SMpyMb0JTJilchDZuoamV9+jBXx6VKjT/2xgsZwvVydjZNXxGX+dpIMTr55Xi3FV2/UbT
	axWRtb7Ozd99LMIo1MVjjJtZG+BMYSo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-9-RmVw9LOWG7O6AoUjelsw-1; Tue,
 11 Nov 2025 08:12:59 -0500
X-MC-Unique: 9-RmVw9LOWG7O6AoUjelsw-1
X-Mimecast-MFC-AGG-ID: 9-RmVw9LOWG7O6AoUjelsw_1762866773
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 440D51956061;
	Tue, 11 Nov 2025 13:12:50 +0000 (UTC)
Received: from fedora (unknown [10.44.33.58])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6E9631800872;
	Tue, 11 Nov 2025 13:12:30 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 11 Nov 2025 14:12:49 +0100 (CET)
Date: Tue, 11 Nov 2025 14:12:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Reber <areber@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	tiozhang <tiozhang@didiglobal.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	YueHaibing <yuehaibing@huawei.com>,
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>,
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>,
	xu xin <xu.xin16@zte.com.cn>, Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	David Windsor <dwindsor@gmail.com>,
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hans Liljestrand <ishkamiel@gmail.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v17] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <aRM2POTDTxEzeF2F@redhat.com>
References: <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <20251105143210.GA25535@redhat.com>
 <20251111-ankreiden-augen-eadcf9bbdfaa@brauner>
 <GV2PPF74270EBEEDCF80CEE0F08891ED37BE4CFA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEEDCF80CEE0F08891ED37BE4CFA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A0B0C000D
X-Stat-Signature: sqc8hgthy6kuabijdkrm64k19eeoraqg
X-HE-Tag: 1762866785-285088
X-HE-Meta: U2FsdGVkX19K+YjjnbvqHXlud9H0HpErty57UMu0ZVNyosYKYpbsZ0URKLS6xOfeUgADPzaBWSpQaDSEjllRJTSHt8BQ1aKMUKc+WsyiqSCmQC7/KllBjdhr9HLRoLJxMY34VSTMii1DxAXGTG2ZQTUPa2ly/y2coWO+X+sqXz03so5tA9OaFOCt0Tlh2xdUXDPqbY+j9FhxuPh3eSHp5wFZk90oze7Ox8YBRdFP9Kwb21etIX24uPkKffj/YuN9Vl7Pi1RG7hXOz4p4EFD5LtATmQ5WPvKnFiplRlPb9EmxV0t0aUyEYXQPW4SIpph0jtO53TE/NAoidJEPIiweCrfgDqKIzcz53INc0AGozYQJoxc2KE7LvsKs781aCDJZ7oBP2qMt+4aUav2abJkL8fVmGQYtcF7thGTkNkQzhqejirnTAYlKzhSsilEDh1VJRh0MGjbHsUmlQVhZS+BjWfRpBZPQ0Hz/FF6hgagXUWYAX/DiDxAj9l4pvfU+whyysHfhtUhKyV2U+IMZbcNMBfqfCSVPzDln2/o6HmKb0D+kJGpOymoTtrDIX/XpvE5deFpVSv6TS3kQD0sddQo3DNAvmZgjRGD7j0g9zmTfb+X2efTu4pf3/awJ9R6nFsdExRoUW28fc0NWmzG5wt/P7XWO1tf1NcBY9uEn8KhdQOfiZhL8wQwU5hZgvvquELPocNTJesvXCkXxuQZoQmbL3imw3ztLfRWHng1/+xOO5j6vfwYQb/vt1Xi+9I2LyjwFG/Sx57Px7pOXtRsHsmVTL8X8rfxCbK7EqeTGiGAqOMP2gO1mpixdiGbud8QO3JPU+HlYcJQr1wHA96eLuG08iURMBSDNfBp/xHNjPsZgFimzQFFm7corElQMPfNPKFLLluBizTCKeOZz3nO7oGFMq0AuHNdbOzbfevmeIvzjGS5k0CoOIeHO3/6ysOpY1tdO+QZVOubXHunrfg6q0Dj
 Mig5yTKt
 WGFwIZZ2i+U4zK5TuIYkTFiftkr1zXY0H1/8HGstjYabeOJEFjg+9BJ8fLy999uOGJWUV5qhW/XzwyzMhqDty7k18iOVoS8mDger8OEYA4AF9Kv3bkIchYnONfyTrfc4TfyHgdOEIUQyNTpd1xIwxbpqOlZMuGNiyd+uLTk+MYw5DTWAbEaL/YPGNs42HZOGp9cjwD4Q4mnKN9PJX7prviImBYqofTknJWKguDRUafVlmciUA4I0AUs6BkVx+odAqkMac/8lW2LB6lEMLyEzwEDHsp/LMr1ZGv7vE42hBe9NoKzVzr4MJHrjCuRkA0+vlCgACJ4E2BnI7Zmo11TXeEnZtk7naXI9fTYrqOg8xbv6PW04BAvkU1y7ay6Ze1cUV//uuhI8l0wSWoieVra2nFrxz0vT+plEfSB7cLGOzhrxWnxosA1Gq8rgj0HZM1/bbJYhcNqr46d8l2pDVXPLcFGxcUVONfz0UOSoknd76NlowadT9lUgbLqMuhRvpGptyG47SG/pVyb9Y43RoqmeHv7DnxUyAN78RGg97aZZzKRGzwTwHigEJ0uxzSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11, Bernd Edlinger wrote:
>
> On 11/11/25 10:21, Christian Brauner wrote:
> > On Wed, Nov 05, 2025 at 03:32:10PM +0100, Oleg Nesterov wrote:
> >>
> >> This is the most problematic change which I can't review...
> >>
> >> Firstly, it changes task->mm/real_cred for __ptrace_may_access() and this
> >> looks dangerous to me.
> >
> > Yeah, that is not ok. This is effectively override_creds for real_cred
> > and that is not a pattern I want to see us establish at all! Temporary
> > credential overrides for the subjective credentials is already terrible
> > but at least we have the explicit split between real_cred and cred
> > expressely for that. So no, that's not an acceptable solution.
> >
>
> Well when this is absolutely not acceptable then I would have to change
> all security engines to be aware of the current and the new credentials.

Hmm... even if we find another way to avoid the deadlock? Say, the patches
I sent...

Oleg.


