Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 983F0CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16B56B00A8; Sun, 23 Nov 2025 13:52:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7606B00AA; Sun, 23 Nov 2025 13:52:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6156B00AB; Sun, 23 Nov 2025 13:52:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A57AF6B00A8
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:52:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CC7EB61DA
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:52:51 +0000 (UTC)
X-FDA: 84142768542.26.3118681
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 25BD140002
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:52:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YKDph1wF;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujJPTxD9bpRdC30uSmxe6b2EMxZkMuLoEavNYh4TQJ0=;
	b=KWwQj8ko1qSwvFNNxRkRQc7WVOBER4nb4lH5c9hR34/KLtDsI4T18qcG4MphbB4fZhvyrC
	eEMV5C80qX+gHBp4IQZMB1NP1UpPtoYAvRAJxKdstlambtE2pP5LddW7ICZoCV2X8U5/Zt
	EhxjYHi34+n9tTE+gZu4S+c2gaOQrRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923969; a=rsa-sha256;
	cv=none;
	b=69fYyxJmI0SctxUOk6Nzd4GdI3bZCb3YzZekoERTJsU97HXWrYklJa+agPJzN4c4Hd/tkb
	Rs/NnJqLOPmRn1KVUkrxqp3aiF9okp2zb8qMLHFksV93S5KE0+HKBvNfS8IZfElTtjCQzN
	7TbQD43heb1DTAjfvkF5WDLHQM8ezR4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YKDph1wF;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763923968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ujJPTxD9bpRdC30uSmxe6b2EMxZkMuLoEavNYh4TQJ0=;
	b=YKDph1wFKR2BP/A+R9WtfxhRVwrVqxT7iP4BfvpgTD/dRRuZq8HU7qkOv/9xVDlxxMJf2k
	3ivqNCNAExdpYrwogzwm0lUsBgr/r8zwMn7lgMF9jl7o4PHqRXdlFcheNjegB1Ch9sRI4X
	jO7XdtKbPIgvr0YDVfyAFjp/qCXpUug=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-390-bNUrHqDOMnaEBK-yTndlnQ-1; Sun,
 23 Nov 2025 13:52:46 -0500
X-MC-Unique: bNUrHqDOMnaEBK-yTndlnQ-1
X-Mimecast-MFC-AGG-ID: bNUrHqDOMnaEBK-yTndlnQ_1763923962
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F86D1800451;
	Sun, 23 Nov 2025 18:52:39 +0000 (UTC)
Received: from fedora (unknown [10.44.32.8])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BD6E219560A7;
	Sun, 23 Nov 2025 18:52:21 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 23 Nov 2025 19:52:39 +0100 (CET)
Date: Sun, 23 Nov 2025 19:52:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>,
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
Subject: Re: [RFC][PATCH] exec: Move cred computation under exec_update_lock
Message-ID: <aSNX5B9a5iSjJcM1@redhat.com>
References: <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <87tsyozqdu.fsf@email.froward.int.ebiederm.org>
 <87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
 <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: pjngdha7rrc3dnhysy53u96m9ym4twed
X-Rspam-User: 
X-Rspamd-Queue-Id: 25BD140002
X-Rspamd-Server: rspam01
X-HE-Tag: 1763923968-484499
X-HE-Meta: U2FsdGVkX1/0vhW18kgn6PaL+BnaEiZtsQUtRZ5o2Ii2AmwB4/NJbLSqjJTcWiVxBHohaHkvpiOzcT3QsiHQ2rfA7oNj180tzuazuucxkfRcbuanu7w+zkeFyX/kBT7nlNI+jwczL4exf5MZRYIs8nsymydXKce7qpMhNxO3hbYEzTAkSsF2ZL1LSUJm/4OL5UKGYIMqR1y9ajFGfj9MDSPfD1vphGy/9iwnGFCGAJ1vld6O9i8f4hdAutul2pULADMr0D+t39t7P7asmj/rI7gW0IY4cdR1NcvE75vRloXim1w21QV7lBi3wtbvGdGng6iTKBBy0K7L7X1aGZjNITiiGqbab0o2UYvPCJRinf2Bi2hhQ2kFmlbXUAdY8uwbuNK4srPhmRuFijqCFHzr+b8o6fWZSTR0t0QI+MypLg2xB0iI4WnRquAZrRAKicQ0SxxeUgZU2h/9+47o9QvV7JPCPJmfDO2rvbOcHVK2XOT12/X6AmNBK0GDt+0YZ0zFpGb9VwblOZl0kkoAQL7ZpV1u2yTTzt0OksPFuFcFsdDoQgcMR/HUV3aJwXMEoDzB1voHk7VfdLvew0mt/4XFUz7RfA1FIkgY6CDevK/9m4w5TWyP1AsTx0XIM/lMsKyTS4mG4eU5iEi83TJ8avenPeAmnTSTCWt+4lE4sKCUUDLY6Pwx7FHdJCMhHkgXjILxXtxZlSUMeGuEV04OnBn8+Uhmw2VkzZ4uKS3O26FAiY31bd7JAKmjU3+NJ74zh8eMHFaqoLmFakDhlHz67LhTNQXr+vZfRV1pAuNKiVp2vbuHlJOw+Z3RI39piAj1jPSvtPNlpzkU1jfVyY/V2OsFFbduHTk88kJ1enxHrx4vikzrU0RpPd0vCuY7YDWyvtDfwcNJH302+nYF8FJzsDjwbCpvQdhPV4kEi0CZ8Tn6aXAcnOeQ/Cx5CBwyQnl+BQJ/ksKBeSpHXFsDplyUI+8
 sWpgXOwI
 ZllCBJAZQNG07pvuXQhRNufOih509+eMKs/9RuHp5oJbq0uDmjOj5SCpyZqEzBlTbbBH2ijQ+DvemWBnU4W19TfBZTHipszQutTSW4fGGKPuO9tbaD8im+gmKVB06DCZZQJ71F1WRwoUnxLrV7Z+uRjNQ+663u5co9EjdeqQUM42Q6DSyEcCRccJok+e+RZ6UoG8MoThdYTCanhznqz1D3E5BVqs1VaOHBFpV5Pjwa8FtmtDylDLJEIfvbqzhGcuv0gC/yBbqhozlcEavpweLww4TAeS79PJ03LqRZOozXCwyLr7M5BQENy+p8MyYoaoYMouoSl3bOBH7y6lgK48LwCp9VWrW5Z4rcx0U7ecZYpjYjr5yqSxKxArO21xPnHFitl8UI0q1Asxc0Jk2n9Kq3+KxJQnnNHzTqIuWjumXhT9B3+EzgJjnjEapuzVcpa+DDu8x7Ki0orinZQF5L6F38gHUw15irUc0Xzc+gYrTH551yzzD7lMoNFsxre9HgyxrLfI0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eric,

sorry for delay, I am on PTO, didn't read emails this week...

On 11/20, Eric W. Biederman wrote:
>
> Instead of computing the new cred before we pass the point of no
> return compute the new cred just before we use it.
>
> This allows the removal of fs_struct->in_exec and cred_guard_mutex.
>
> I am not certain why we wanted to compute the cred for the new
> executable so early.  Perhaps I missed something but I did not see any
> common errors being signaled.   So I don't think we loose anything by
> computing the new cred later.
>
> We gain a lot.

Yes. I LIKE your approach after a quick glance. And I swear, I thought about
it too ;)

But is it correct? I don't know. I'll try to actually read your patch next
week (I am on PTO untill the end of November), but I am not sure I can
provide a valuable feedback.

One "obvious" problem is that, after this patch, the execing process can crash
in a case when currently exec() returns an error...

Oleg.


