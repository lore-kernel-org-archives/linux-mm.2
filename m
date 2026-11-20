Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95BBD606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=da3wZGNA
Received: by kanga.kvack.org (Postfix)
	id AB7656B05B5; Fri, 20 Nov 2026 11:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67C86B05B9; Fri, 20 Nov 2026 11:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5386B05BA; Fri, 20 Nov 2026 11:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 749CD6B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:22:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F405981030
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:22:36 +0000 (UTC)
X-FDA: 85456015512.18.A365AD3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id B88CD80006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:22:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=da3wZGNA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795191755;
	b=wJlixIwb8/Yj0SRx4O+RlkGVMt/wAhT61FCdHYg0HJvU/tfH882Rx/ytjvFO3wrD1vOGug
	Z5Q+Ha+vxM7Faq4t/nJnYE3TKul/TgglyEp2GPz/KAUNqO0/d3PP408y5cGbOaWL0zrzj9
	FVt95Djdz2s3PuRjXA5h4yWgr/oC+Kc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795191755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFrxkYlbffnn1oFL/jywinkH4FaLHpHlb6I6Aq54CHs=;
	b=oNhG6K7ng3wRI6X8LCuZuI00hAGGA2R5oiwAXYdUOPtklkSxeOmGx+emzqatKClATe9Vyg
	jSJTul+4KvbGgMHda2imX8t6s8POq7lZROTnt3pxDFkV6V3DIHNF1p3D5B2pyZouOJHXwL
	EBeyj4xf37P0yqZEgdIgt7or/MK4Y/I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=da3wZGNA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795191754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFrxkYlbffnn1oFL/jywinkH4FaLHpHlb6I6Aq54CHs=;
	b=da3wZGNAcn3txpQN/oJHuuAcXyCFKfES68ntbYX9QpopVIY7bpDqgJsb/JliP7t7JROyAl
	oi/YpyXtbS2JV2KRQU18+2XzjJXqumLs9KfDsF4AWKMbtk5n6Whxwl5iLCcbAox2TSN9NU
	bGIm5HG74oJe81UWBOtA7FE7khih298=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-407-wX-z_3wnP92GD2JkyzEneQ-1; Fri,
 20 Nov 2026 16:22:28 +0000
X-MC-Unique: wX-z_3wnP92GD2JkyzEneQ-1
X-Mimecast-MFC-AGG-ID: wX-z_3wnP92GD2JkyzEneQ_1795191746
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B49221955F08;
	Fri, 20 Nov 2026 16:22:25 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 1960B1956049;
	Fri, 20 Nov 2026 16:22:22 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Fri, 20 Nov 2026 17:22:25 +0100 (CET)
Date: Fri, 20 Nov 2026 17:22:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Jiwoo Kim <arpe1618@gmail.com>, Chen Linxuan <me@black-desk.cn>,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/3] pidfd: use one helper for pid namespace visibility
 checks
Message-ID: <awBzvXKHePLzjABf@redhat.com>
References: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: aN1qMa4X18Y5jOiFJ8Q6EJ3UjptsKbR3456906p_PCo_1795191746
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B88CD80006
X-Stat-Signature: x7ox6criqzh9ueyuumy6qmy4mbzfato6
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795191754-385193
X-HE-Meta: U2FsdGVkX1/5bl+3Ni/c+XhsWgnixcDYCByEbvdLlmQPIAcsyPkRRErW6SAR0j6lh13afbMs90tXn9EWo1ByEZ1my4yL1meYRdIM7v0jrhMim8Klh4lliBzQDUHL/g1NRqXzvciKSCyy1lMjQG31bpmvsAueTe70ZGh7s3KZYn/GqeVnGE2dQE35N56yIF0Ah51hUezEC9VVsQilp4yHftbRB1aA/TbqvAhYtawzrrVT0S2Dsq9aaf/UfuZ8eTKijR7GFi3ZiGoXlTUYhv1HXxhvArB1SP2/033ZNht6i4AXIueL65UqgpBixLuBNNo29gb/Kdhdi4agFKlF2L2JKC5WfkWkVrYfiDlF5eYpj0oCdiHx0C5zg5p86uBKCUs65SNIlIhlc9J4ptWuGAK0DSu1y+t7SMRrYInLIeHrK6BHR8PvdKu0AAZE7oRMeIz2APCni5v/VrGkqpfmT+RflaaH44ydKWrOSJOLK3jL9Q9fSkyaQFGjcpDsjELPDTOTDGk1qWhqsUjyUTYwL+o3/gDYUrO7UsH3elw694/yTFZHIaR59rJsHj69Iq5j23nAyLQ7yq2vR4mAgJDzeBwKVVP9GDaKRXLKYoUjtl2SuAILqnPaffEdFzp5CZ97eJWLDh4eHtU2udn/vfTvQSwUFWYDnrMKkZ6KAVt71u+twDZxvZATulKABiIjHc/hIZcIKjwoyl+SwyKwcE8rfQxQ3HNJkdefPl/u29RJ+nNzzohtMKX9URUhL+JEtlCnljM6fwD3ZjHiL0m3+9PqadbIdJpb5Lt9oMaEVF7CdnAzFsPaBA0J1pWEgngTJ4DKgLLc4+tnUUsthnyYAr5VLuR0OM6UzeDRMxoa6/UWlWzh+JacH3WWYppbb885/OQXf8K1tLcqV58rIIFYiO+DaNAljThaJUhIEHaJRYDWVtecxPI19N5Mm9D6LR0XftyP24Qq4M2ulTTxg8SFK1TSmTe
 yhNWWHuk
 J/nOU58Ll8RsvfCbKJlB24o4PBj3PqEz2nBG28/+TcIFFFNKCbLf3HINONMAU/aEaF9VzZf2MKpAtnroE8SXEA0coCrvLKw9wnSMRnfafCQd5IMYjM0f7U9cfAsbL9amnPdCRTrGoRcbpYDbxhGfapZH4YmU6DGp17Wg4MC5hNkKbXsSNqcb71CM0F3uKW/pKW388faPuaO4tW56j2QHDqP2SifSS/im68ucyup1KRL/SOMBJxFtvUs+VcQBpP7Rk15P4hiBPFEUyTWslbA74jqATBUk7rYk19VIXIwnrvj6QwoXZjlbxA6jI9YAPsi32Pz62QA1us6LPUBcumD/qCEBj4A2+8oLFzFvDzE6kefwpwTS8z1EZWQo8G+U9b6QEDPrY2qjK9DER5m2pTqAZa6M8maOmmuQ7IWW7V+kausGWV4Gjh1Qvcd0rAsUQBaAYiMePBsj4dxcZWjBszflQYblrSPSnDTmtiUZYlLormou28mDbX24vEa6xqfv5Yro7UGY06eHPA75D2SlD2IVdLn7Tysatv1fKBLFunFwsRGbkJSrEAkreqqozEGNXOeQVP+hMZn+sLZvEQk/RIgxcf/9nhRZxozuQFqJe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20, Christian Brauner wrote:
>
> Christian Brauner (3):
>       pid: move pid_in_current_pidns() into kernel/pid.c
>       pidfd: convert remaining visibility checks to pid_in_current_pidns()
>       pidfd: restrict pidfd_get_task() to the caller's pid namespace
>
>  fs/pidfs.c          | 12 +-----------
>  include/linux/pid.h |  1 +
>  kernel/pid.c        | 31 +++++++++++++++++++++++++++++--
>  kernel/signal.c     | 23 +----------------------
>  4 files changed, 32 insertions(+), 35 deletions(-)

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


