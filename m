Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE0AC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265206B00BA; Mon,  3 Aug 2026 09:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDDF6B00D4; Mon,  3 Aug 2026 09:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B57B6B00D5; Mon,  3 Aug 2026 09:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF4036B00BA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:37:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A140F120669
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:00:29 +0000 (UTC)
X-FDA: 85059513378.21.C13C25F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8900720005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:00:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F2pg6dir;
	spf=pass (imf13.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785751227;
	b=oouUB1GX2lznQTMBy6Jp8iANzQ5gVHNQ4tyz6RKwsIXAM2+XqbQgjnYjztSLZ2wJMAxqVx
	7LJyL9l2NCRHes8svlfNaGoBrtqwMvUVe2P0fGqGV4S30J7tL1nqN/mlv7trSbyBle9c3y
	OAuFyB9pT3sZC741nk/CUfo8ms5YW8U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F2pg6dir;
	spf=pass (imf13.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785751227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSbzfg+WF8irzWdRDzhVCU6AXptOY9bPmk0b+GI3hig=;
	b=OEj1t3KUYIF+TVQB9u6SimuAI+RLScZnbdV+NitQET9XQGogKJyauFwRudcnMlYOdny6I6
	IXhRyJRGMo1UYD3eRW2LzEj5l7uOt6iuY+9dOxNDcUnlI94gjzqtffIiWCr1j+4zK0Geyf
	/0wgJXUC7rcle3KQK+uxWPDt3nUXbqQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785751226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wSbzfg+WF8irzWdRDzhVCU6AXptOY9bPmk0b+GI3hig=;
	b=F2pg6dirP1sPwUhU8JAPjGR98K4srZHMInEeEZqZ3eiNnuUIzeVolnw2xlZDdP6CC1mqEM
	l87Oo7jW1KHs8E91eGfP9+OSz7e+1uaT01AI24Q7GS/GSAoFwrJjYSe69E1QryYoP1XtWU
	H+kUD1UAErWAeD6F0J0qP/gjR392b/0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-5OgXQmzJOZ-Z3BY2OCUC2A-1; Mon,
 03 Aug 2026 06:00:19 -0400
X-MC-Unique: 5OgXQmzJOZ-Z3BY2OCUC2A-1
X-Mimecast-MFC-AGG-ID: 5OgXQmzJOZ-Z3BY2OCUC2A_1785751216
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F46519560B4;
	Mon,  3 Aug 2026 10:00:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5B1301800480;
	Mon,  3 Aug 2026 10:00:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <79610b53-5201-4af3-913a-0c4dcbb6f9d6@linux.dev>
References: <79610b53-5201-4af3-913a-0c4dcbb6f9d6@linux.dev> <20260731154608.153258-1-linux@jaseg.de> <am38qk60mpVFuJRi@MiWiFi-R3L-srv> <74625f78-15ea-439f-b9f0-939d2976fa7f@jaseg.de>
To: Dave Young <ruirui.yang@linux.dev>
Cc: dhowells@redhat.com,
    =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>,
    Baoquan He <baoquan.he@linux.dev>,
    Andrew Morton <akpm@linux-foundation.org>,
    Mike Rapoport <rppt@kernel.org>,
    Pasha Tatashin <pasha.tatashin@soleen.com>,
    Pratyush Yadav <pratyush@kernel.org>,
    Jarkko Sakkinen <jarkko@kernel.org>,
    Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
    "Serge E. Hallyn" <serge@hallyn.com>,
    Mimi Zohar <zohar@linux.ibm.com>,
    James Bottomley <James.Bottomley@hansenpartnership.com>,
    Rob Herring <robh@kernel.org>,
    Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
    devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
    kexec@lists.infradead.org, keyrings@vger.kernel.org,
    linux-mm@kvack.org, linux-security-module@vger.kernel.org,
    linux-integrity@vger.kernel.org, Tao Liu <ltao@redhat.com>
Subject: Re: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
MIME-Version: 1.0
Date: Mon, 03 Aug 2026 10:59:59 +0100
Message-ID: <2490025.1785751199@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: bcIg8cNNKJmzvi7RYQ2NQpBK1JWUyksYiz69I1Xfxl8_1785751216
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2490024.1785751199.1@warthog.procyon.org.uk>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8900720005
X-Stat-Signature: yh631hio7gmdwkcahujuyaydzobpfzsf
X-Rspam-User: 
X-HE-Tag: 1785751227-993665
X-HE-Meta: U2FsdGVkX18OXGo1iGqlHIDE6VW/k8GixaRwd4RXW4kyOlnAmGz6UTrsL2gYkjQZqTYAEMzUM6mq87hi7RjLWsUdKSGO4eX2uNmLYhg1N5GroRL6Soo93YuVqxPX+4Ueqy5WH7/gSVnKsAeCcQysYg8SODfAoVEo9RJocG0c6maGD/di3Vq7qO1Cn5Szl6bbl6HgSGTvvbGWt0r4zE9+QMQInKXIgROzh0mB4xburAKk/ectXLrwOFDq5chnDRmzimi0ZIxcxiZxyCxjSJkuPep2DsopfyihJIt8R4sbeyQ+dBL75Ky65qJxIHPBsPMZinavEoLSVXJM28zI9GDkZmr8GM2OSeEMg0b6xurEFPTwncQ8ITa8N5Z49hiEM8p8HOrbEEt2lZaY3Uvou0ZU4501RJFr4k0LzHTomXqer29lIiphI8C34S5gNWhjM9Pn/mLvyJpNAdj1fW0IHfG2FGuBFHwRmtqjg/1cEzZpCH+P0jRmvqI5xfjTFAEf281MaN0Htp7wUbiJTlmm7W1WGM+p/a6xxrIkEoSnPdpBUSSYW+63/KRNAgjbX03aY4p3KKmX8kA5ro7HUJXqfiDlNq6JkaP+NULuG2Y9kqklNRqYJatJIoeINqznI7Bl8VcUo0lVUgKSTmPZ5uO8G1tGwaDYpM/wmzXgzZntNYakr3T+IHZQsSO3HV6s/tghEmLAu/DcUgiC0CRGxMPLmrAFQ+sOWRFsBDjqxw1NNVAkyquw7TriJMNmlrgAVgd6bLDePVC6XNZdLve3brNuksFM/eAjG3HDZ3qamOR80CbaOGBc0l5LBuiVXvh+tNHVrBIWFCp4xxUHpLGod6lzS95nNQ2sVjm7UbG2xZo5HsUm4bdywnTXeQzzCj4Escx9BiKTMw7H1kaqxWamWGBW47Blo6iDVAkuEDI0cm4eqLlkrnU7RYRSjOUygOXZl7tL3IY2LTFy0qZEdY0JW9+QZiB
 9pdSfCE1
 2PVFbsMTHdcH8q9b2yWgo8bYthDzIDdlU0kngG6R0IraTvmgmYIPla73/tNkcnHQyCS/aXrtRCxzH7LIMmlPg4qB1ovCi6qkWA7p417PLf8uLvHd05CweWU9rVQ+ifSdzQAKvgpnN6o4D2+xJ6z5VJCRC/2AFzACgBEiJkci2VYy1/Pe+lb0TCSsonF5iy9Csflwee6hPioIsST7a/SmGkQ1FnkBkQMA23byCWWEh4bf7iS4JAb46ObZMts9ptlF1sBU8jlYaEmaz8NgGZy4OZ/+zkDfpZPzIypMFNKwxph8hGuJv4dpy26lb5wTDgkh8eD6B2y86GkJpw6R1OgU5QKCTNGdy2DUaU7lW8dX6zlZXkGVB+b+wgcIZK5EeZYKChlc5qRy7I5FzA1Ymq+X9bsJaZtEFxD+O8UqWcGE20+mqCjDapcQ0Kzlbsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dave Young <ruirui.yang@linux.dev> wrote:

> Cleaning up secret data can be done with makedumpfile + eppic scripts (see
> the manual of makedumpfile), or it is even possible to do so in kdump kernel
> with Tao Liu's improvments for makedumpfile previously (I don't know the
> status, probably dropped for the time being, but it is possible, cced him).

Does this represent a leak of the secrets?  Also do governmental
standardisation bodies have opinions on what constitutes a leak?

David


