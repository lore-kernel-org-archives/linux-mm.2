Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 877ECC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910176B00A1; Mon, 24 Aug 2026 11:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7C76B00A2; Mon, 24 Aug 2026 11:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE2E6B00A4; Mon, 24 Aug 2026 11:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57D3E6B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:03:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC636140173
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:03:46 +0000 (UTC)
X-FDA: 85136482452.30.3003319
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id B08EA20009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:03:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DoXWHiTU;
	spf=pass (imf31.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787583825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZ3erjJduSWntjWxjPCCJpediljarFwjV+7IHAqxu6o=;
	b=FKV1dzxUFj4hGH2QwuEHRN3chI1W+aF7k8IJup7PLQMbYw9ST/yB4yr6JimquCUwFajLou
	aLQVBIeh7X4ixoERtgeZURiUNZhpqRihSQyZFC0Yhxhlfu/LVaSMK0uIMFM9vSH5Dy2cy3
	aAnBJxLRs2rPCDfH0cwFz2xJjhN61OE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DoXWHiTU;
	spf=pass (imf31.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787583825;
	b=4B33/CNp6dX1Dc6jWozMtB2pXeK5vxD4yUZwoxu5oPOMWChaFXNtkIfEaH2GVkQs3oTYsv
	pnyGWW3lJl4vLfLB3bPm+8je5MMff1sXsl3t+81UDLzHqxxoPWPyIXGmVyWt6+8JHGuUcc
	gnS/we0QXYAy/rV2a/mUom2QU6KDAPo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787583824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aZ3erjJduSWntjWxjPCCJpediljarFwjV+7IHAqxu6o=;
	b=DoXWHiTUWI9RArWLzJNxvceZ/qttsOqQxUe9t9S6Ovxo/JoAnhh1Nr7d6K1hVwBWXgRKj+
	gNrPwb0Uloc00hYqfDmd3pt8R2ftyTJrL3wfoNRnNky2gn9+p+dk3deByCH4qgb9mUQhAu
	j90RJUHnR8ZIqJL721nSX3MlMcsgDvg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-2cWygwANNtm8DIgIiEXztA-1; Mon,
 24 Aug 2026 11:03:38 -0400
X-MC-Unique: 2cWygwANNtm8DIgIiEXztA-1
X-Mimecast-MFC-AGG-ID: 2cWygwANNtm8DIgIiEXztA_1787583816
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B3BD1944F01;
	Mon, 24 Aug 2026 15:03:36 +0000 (UTC)
Received: from fedora (unknown [10.44.32.9])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4B0C630002ED;
	Mon, 24 Aug 2026 15:03:31 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 24 Aug 2026 17:03:36 +0200 (CEST)
Date: Mon, 24 Aug 2026 17:03:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>
Subject: Re: [PATCH v2 0/5] Stop TIF_NOTIFY_SIGNAL from interrupting work
 that can't be restarted
Message-ID: <aoxdQmFMK7pjH9qk@redhat.com>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: oBSvJMV9T9mSaiyNYWK2x0RLAmr6QLAJteXxATwYmCg_1787583816
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B08EA20009
X-Stat-Signature: jfc4ydp6c13bsh9akiw8r76zdzyxtmqg
X-Rspam-User: 
X-HE-Tag: 1787583824-170408
X-HE-Meta: U2FsdGVkX180+HuD7JRK0QpxTU9wu5GCr2VBo8OXfPGluDB7kOFhsRzxW5ijfyq5tTW2psMkuGuPgCxt34Jwps1Xt6h2MRY2EQ2QzwDSnrg2uOrCnshftC3ppgQcYjAN1KfZE73oOE4JSjhBfmDLWUmgY5E5Vj5nzmzrxmlqaRWlnGD2aMFCZN82d+F2u+K6A2Cw/vo1V7CzsZRSgNWzlpKbzZcOVMiFq26MZDeCtq9vvc4gjgGnwQZrVq4wJ/zonylLOnoDoGZ+t4GAxPSm/VStlIyxqiaKFVbDjd2uf75oNq7zJUPNXQquX4pJMYdROB+UounKlk6y3IG7bwyl/Wk84tSEduNRfmVWAADcYP1qX6DbErYf51wI/E5hCv7Y8xgDa79W+XUT32FVNl5UjBKWf8ftn4aWdC0r/XgmNFIiSXvoMTZ6d+I9WPFk7c4IJPi9y78oT/3VMMRGhIHVLyJfCgZl8ObJ9b80yY9j6ovCS6iIHA+4Gs8911VopQoFveNKwy9wGwaO0quZ46w0PPn2NcWBZxp1p/43JYsrkyEfH3Qs/K4zo3o0d/uv08iZoynsSirOGomw0fgOGRWOw747SqzvLb4XMNV02Nj74ayCcRG9gmPkbfdfcIToQ5/2qfFrG613Xizhgrb8SzKyVThABiavh1QPu/nmzphQTZ1NhODi26KACmyQNGq92zAXSEL0wTRWDqYbHYrhU/kGNdWCRjP9JGlbfO4z++dqcKHXiTnQFgw8qi5KwBL2cQkfbskdXMQGc7pbvVM8bfvW39IHfdlHiYj4b3WD7rgK5S2I2p0TK++T+B8hDjUrUKvqZuWdhXMC3HRQed8TxWvMVbJ+8tJpUxK1p8b7BzQtgbOBupDnUOdhuLcRfwsWN7eoq/GgH+93VdUGlql+Abw6MkUqYeLCzkJNxrRbpI5TsGllGbvEobGs6AJ83MzlYtvgTKimCN+DM1TtDJ3tpfa
 EbXBDfe1
 9vIx7oQTQzSS8EEOGHc0O2i/dH8sxujwoklvOI8RCVOpQCBobuKWsbPk4pKLC3oQPUeuxCZkRHcjtBriHmAN5p0OPLG+02sZ77X20NpDNYoc19nbI6O3ases77eskMBVOPLiBoKUju7Mtrpkagov2WDNtpmksiebL7FOzRpbxih3/uwIMkvmdeoRbZtOFb0HvOFz2XConJmJ9l7c+0Tga3+sNoN//FNCDqbPsPX70KeJEatSc8yWPG5qq59DLmH/M1O+yh9/XO4aGFa6JrzyYTo3JjTWU7lLj9m69Xspd7vAqUX0Y/MiEap0lB1M9MPxD/A8PrO+Ti9/p2pNvUh9gs1Un+0g6RNZJaNlsLv3AAGDx6babhBCWXDp4c7T8aqpt6RqtAD9lscZoXcIgjkptlAi5C9vKWe5JzeZdSZrzB/a8bGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/24, Christian Brauner wrote:
>
> Christian Brauner (5):
>       signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
>       coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
>       selftests/coredump: test that TIF_NOTIFY_SIGNAL doesn't truncate a coredump
>       smb: prevent TIF_NOTIFY_SIGNAL from interrupting
>       pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper

For 1-2 and 4-5 feel free to add

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

-------------------------------------------------------------------------------
sigprocmask(SIG_BLOCK) in fs/smb/client/transport.c:__smb_send_rqst() looks
a bit suspicious. Even if we forget about TIF_NOTIFY_SIGNAL, sigprocmask()
doesn't necessarily clear TIF_SIGPENDING, nor it can protect from (say)
do_signal_stop()->signal_wake_up() from a sub-thread. But this is offtopic.

Oleg.


