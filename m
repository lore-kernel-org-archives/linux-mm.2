Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89DCC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6BC36B008C; Fri, 18 Sep 2026 09:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D576B0098; Fri, 18 Sep 2026 09:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BAA6B0099; Fri, 18 Sep 2026 09:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A39C6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:42:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81BC51C2EAC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:42:02 +0000 (UTC)
X-FDA: 85226996484.11.F4595BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E68D4000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:41:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bX/l51XD";
	spf=pass (imf01.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789738920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1G7pn6seS/SOuHvOw8pJc1Knwr72Zy5SeN7YDV021M=;
	b=Tyk/6F4pv2RrOKsaAX4DZdNGWoLxtVCuUpNmxqgFCihCi04tv5oPOgkcBDxrj6qLrEknsE
	GLIRptMaP/Eh8vyIZcpHNrw2EJTk9tbF3tCmvxzARq47VeOY7v/x95YFL77D9rtnyOMuKq
	t8pTR1HDyM3G4mh3cHAdICazMvVeuys=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bX/l51XD";
	spf=pass (imf01.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789738920;
	b=mapyj/YoS/55Vc2F0uu0h0KSNfo1gIpITEX2MUVIOi7dR4pyt+ujZ3QEdNgK+SJjH5gvrd
	lD1b8JR7zBq7vSeCpaUBJGmSxQSnlSa932b96kqe52JjMmNTcC53RyO8lsdCQG1boZj0/+
	hKsSRgre9ioh4w9CCT7DAT8Oc1NJbSo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789738919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T1G7pn6seS/SOuHvOw8pJc1Knwr72Zy5SeN7YDV021M=;
	b=bX/l51XDyTJGDG3oQfCJ6gjXjd2uihUTmvaNw/zhDGaxK/cwIEWaMVybcvL5Ib4NMOs3vV
	FbGcIfzWSJfoGWq27eJKFxg+ye4ghHAjmIjgujWuiX+e1pyIiuYMp3HzXWk+epH0Ds1KaY
	VwHJlTmeZ2JV3BV2SHNrHBcMY54r1XY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-179-H0K6Lj2APcaU4-gCZgc4kA-1; Fri,
 18 Sep 2026 09:41:50 -0400
X-MC-Unique: H0K6Lj2APcaU4-gCZgc4kA-1
X-Mimecast-MFC-AGG-ID: H0K6Lj2APcaU4-gCZgc4kA_1789738909
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D66E819776A8;
	Fri, 18 Sep 2026 13:41:47 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3B334180034C;
	Fri, 18 Sep 2026 13:41:44 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 18 Sep 2026 15:41:47 +0200 (CEST)
Date: Fri, 18 Sep 2026 15:41:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <aq0_lvHDViIpX_Mu@redhat.com>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
 <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
 <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
MIME-Version: 1.0
In-Reply-To: <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: jDMIx3zF1KnTPPs2S6ToTEM4NEWYdqUEHxc36-EjZgo_1789738909
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: 74qehrqp4usxy6iqasg4w9qht4wdk18b
X-Rspamd-Queue-Id: 1E68D4000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789738919-619631
X-HE-Meta: U2FsdGVkX1/epUaMw2Wg8B+08jU0lI3cf1B+RNafLEWTHRiXJJZNeIniwnClBpKt1CUpvvDG8uTMa+pfh7fnjU+louwpTinXa9tpZ3uVEaDmM67OQ3TY4EUWrjI26FTPETfZGf76UPTf7s1cPydSSAcL2KipoITHBPBMPv3BK2gRJ9zecM3bNQDplQBDS9jD5UnP0w/I5rVBXeO09kjPbxxISUtMcueN9Xk/hXLT13m2mQ6sac+QKdy6TCDnRDXTXNlCH9rzAiQ+DQt8/MZWsFAhN4R+JMYZru+o8+LLU7pvMwVwztwXF0o8ZhXG0MP12deYkjE4mIkFWRxj+HIRpZQL8XNIF1wFeNEO70LDd0oeEYXbevwm28to0xiHl2UV39rTLmkZlFmIpwvLa4uUi8nWFamIt6iixUbK93jLMSAwVafDj5b7SVun1X1WTx/wB0MoWhJyU8WVGP3qqjAEbP67p28Y5pr6vxAORz4SDKhpXEtl2VVKVGBTRj60w6IDNWjf71Tb8NORD3Q3+DMlrXdBo4UmFZIlZoYkwTrZ3ChIH1c9YFGqxd5Qig9DWx4HL4Uj24XJeJx8Y18CnefE16VKxwqj8U8AbVs5RM5vNhmIxp5ynuurcROIPiOM629kWBJv2ivsp0H8iNTXQciJxmvsyjxauDD+hG/AB+uqiHs1mAUIktgCYtTQDNBJBC1RjalwzNsoI4Tr/UXGQmKQGcxU5lkSn0Or4HjG6jqw8qusJDykNPJj7UajsTxpcaAfH/YqnPQm3iEzWLdmXQqRbDTLQX/oMBiRCv72hLmb76oJVnNF21KbcTb1/RLLT6gt5P9YVxT5M0wnrATxFe1HlDLxsLkloNOTwwdkweoIpYe/HCL3XJguBhv+8NZ8ynA1RuMRXAH2MU5XaFEvV4HtannoAmCzLfhPAAsfHZrMmNR/PEiW36UlHeQPMFlVk8YPz/+iNE4vvwgJT7V88Rd
 Tzt8Nq6G
 OYNjzDAHd2G/Ui1iuVWY4Ze/3AK8Z+/5/r5r35l6OyE0i/ondkGp/RlKmFw7cB/ZMNdngCbPdVbuynFZIs1eIy/glECf7zbo22MOws7RPAisOyqimPkYw3pfNRgFm5oJgyOQGnnrZbk3m2tfkRBVTEzLrPWpKO/qjGgSpF0dEgtKjewvyja8wrAD7glIAj6fr87zFXn42PMMSZN8M8HoSiVh/L54Hge3UzUnRiTO8VTGJEx59G6JWhX52IknWbP9tjgfEh9MrFoosm6idWdCQPx/XGpIlXpHy687BGQaEGg876p0jS5QI7ACMUqWR2mR9KG4Lv64EM9HCs6W7mw825e5+BAPW7napp5t1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/18, Christian Brauner wrote:
>
> I think this works but they also need to check ->in_execve as the
> exec'ing thread is obviously never signaled:
>
> @@ -2709,6 +2707,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>                 .user_worker    = 1,
>         };
>
> +       /* A creator past its fatal signal or in execve gets no thread. */
> +       if ((current->flags & PF_SIGNALED) || current->in_execve)
> +               return ERR_PTR(-EINTR);

Ah, I forgot to mention...

Can we shift io_uring_task_cancel() up, after setting bprm->point_of_no_return
but before de_thread() ?

I know nothing about io_uring, not sure this would be enough...

Oleg.


