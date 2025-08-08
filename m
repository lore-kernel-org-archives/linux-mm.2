Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2637EC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAED6B0093; Fri,  8 Aug 2025 10:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BDA6B0095; Fri,  8 Aug 2025 10:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33E76B009B; Fri,  8 Aug 2025 10:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 908C96B0093
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:31:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13D70B8114
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:31:35 +0000 (UTC)
X-FDA: 83753828550.16.13234D1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1BFC740008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:31:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MJVAMQfF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754663493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVhHzmrsz3RzEJrixBNs+yxJAkbGyaM42AxRbLiYFUU=;
	b=y7PbeUViJ4MxHqKloaW7EiUXyX1/5n3fQwID4OjHuMgQ2PnlzKkAFhjmzqThGcJzLUS9BY
	4s6q8gUhkamMr4zsfRz3GyGttuQCsohFW7G07t5WR8XrGM1hISCtTxy3NKP310fo6CzKDl
	k1mk3w+VqNK9S8osgGxxStFUgXRfF8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754663493; a=rsa-sha256;
	cv=none;
	b=8CM/sxkpqZ5RFno6y095MHhqwIGx8PG2DCM5vZAzaNhZLLnMcHeSV7pRpAKpUttJYGxjb4
	gxBupZOKHgxmQSexe2Gk64rjMmgXn/PlvCEqiaM+KoAQ8qoocCO3HWzUcjANb7KLUF1lqg
	rTwPbJ1QKaohgdQcBdBxDGbcL6fsHLg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MJVAMQfF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754663492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVhHzmrsz3RzEJrixBNs+yxJAkbGyaM42AxRbLiYFUU=;
	b=MJVAMQfFzpKKxxesbNEmDeK1jm/5K+NNm2oTAkGeBFpQYT3pqOURZztRO+JDHrHaKzTmjB
	yKXMVLUVnvw9Mz6p111bj7cEqaC+gzSCYuNU+sFZVDf0TmIJDGRPvcMraAFOCYNXPUpuSl
	9g96LhwHUxVYMxYygRxtW8tA6H6zuYg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-DJbDAkNNMHyGQLED60pccg-1; Fri,
 08 Aug 2025 10:31:28 -0400
X-MC-Unique: DJbDAkNNMHyGQLED60pccg-1
X-Mimecast-MFC-AGG-ID: DJbDAkNNMHyGQLED60pccg_1754663484
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07B30180035D;
	Fri,  8 Aug 2025 14:31:22 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 1177A1800446;
	Fri,  8 Aug 2025 14:31:01 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri,  8 Aug 2025 16:30:10 +0200 (CEST)
Date: Fri, 8 Aug 2025 16:29:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zihuan Zhang <zhangzihuan@kylinos.cn>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>, xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 6/9] freezer: Set default freeze priority for
 zombie tasks
Message-ID: <20250808142948.GA21685@redhat.com>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250807121418.139765-7-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807121418.139765-7-zhangzihuan@kylinos.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 1BFC740008
X-Stat-Signature: wnaxt1dcr16bs3nfydheqrmko3yopgge
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754663492-467767
X-HE-Meta: U2FsdGVkX1+svkKy431L8tP0rqf/JEIUL25IrIH4uXSXXUEKxgDSSSmsFUmp7jXIUFKq0Gq2JToCexC/XQJNcwo/DS+SL77Bstbwlk4AxDv877TSFk+9f4UbYdhdUquR1ZMEIqiCNrzKr8sEjz9fVs7qn4meg+0vLuqmInrrofWsBcQK0bPkwlK1Iany37ktUJnBED7Ra8I0ekdDo2nN5acTyTGaRTj6ucEcu3Ikc5i54i40/bUO1z94T0HulMDiKLrzHUzhLAEZjx2T8K1WJS07pFM7gKWgjp6HuvKMxdDRz1F6ifG86cgHKPSmzIHqIYkF8gGiF+l4YbEuxYYCdjhHjjOOeIFKR5ep2I5i/1ZOQrXTBKZM6cZW3N2O0wyF3eYR2dZpCcqkx+drgSgFBm5ZG/gwvK9rW1hXOXA/wspMjq29XtYTKZIYXSurhnN4xPeBidylxNd5hl3gvY0eKNdCRPTyt8hH37lPEgkKeiW/tND3Cv/j0Sxstlz157Ei3VUWtn57w0kdNtBQYx0lRrN06KSd92OSlNJnpfVAV02eEY7OmRt0YwZqMSfkU9zV0ptdpDk6Q5yFr4ZcKciGVuQDAtthDPYC02LnTaUPeWAZrhCxgEfHtwDly9SMCDQ1HskWi2FzMth3fD3L9TFyKL9gxxJrvTftHQYG1ZxNfYIcT2h4q3TC3EA9E0zpxPmOQe5YpPWDnGnLTtQ71cqmYRa6k8OdYjYVfoAmmXJ8k7v/ximL/2XawLoJmMXcJRydkNsUxIcC7yB40yg7zVaFCCzJr0svDXnAilNT6yGdCZisxJcssI++N1vpZReEWERjFNb2OdZjTidMOApG7dVIS/tv/Iohwi64jxJFUPSeCC9jMcHqMyrl80pJ6Sn78AQBR7xtkd4yCg34/+6kMFbeiVZetwvPF9uAMcWHZ9NUQaXpgS1b48bdoUiCdb3pXSvPwB/+9LwGiRcJzRa62n4
 buCueH+A
 0uGWYIhTf2+OIGaVFoGLfXWMxew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07, Zihuan Zhang wrote:
>
> @@ -6980,6 +6981,7 @@ void __noreturn do_task_dead(void)
>  	current->flags |= PF_NOFREEZE;
>
>  	__schedule(SM_NONE);
> +	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
>  	BUG();

But this change has no effect?

Firstly, this last __schedule() should not return, note the BUG() we have.

Secondly, this zombie is already PF_NOFREEZE, freeze_task() will return
false anyway.

Oleg.


