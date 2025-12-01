Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB93D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BC36B0022; Mon,  1 Dec 2025 05:56:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7532C6B0029; Mon,  1 Dec 2025 05:56:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669B26B002A; Mon,  1 Dec 2025 05:56:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56BD26B0022
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:56:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED7A752501
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:56:13 +0000 (UTC)
X-FDA: 84170597826.22.747DF6C
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3554C40012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:56:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=koYhKZWR;
	dmarc=pass (policy=none) header.from=sipsolutions.net;
	spf=pass (imf01.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764586572; a=rsa-sha256;
	cv=none;
	b=pXqedKefHH3r6dd0kXCuUM9qcsBmlmWwZSEsPri7uEBGjk02OZ9v8LbMV4QzHHw1WNQP3r
	dZdM9UXjaHpgLJoPNrHgOxGAotJHLCWmHM3PTlo77OaPJ9hEP6q9hkwmlFxJDFcOXg8jxK
	+KWz+t9QBQWOP5VZbBDBL55SbtaFHvc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=koYhKZWR;
	dmarc=pass (policy=none) header.from=sipsolutions.net;
	spf=pass (imf01.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764586572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiRNEO/XNBxkNs9MPPdlx3M52d9PmW2KoL7nHem/Ym0=;
	b=EJld2QooTQsF6qtzrsYy40gb8BzJupNEAfAQ3AXOi6B/5/VHXZa98nv4fPiUoe76cV/Mzn
	BnfmrQMT6yuSy4cBRY/mS0QVwljSWlKNJaqZrSreHjL1duMqkDjWqRwXZQWIqer/ASQcqW
	oC8wz074ql8BTrKUhIwWG253oJmuMfQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=tiRNEO/XNBxkNs9MPPdlx3M52d9PmW2KoL7nHem/Ym0=;
	t=1764586572; x=1765796172; b=koYhKZWR09h6FhbFFBXVQBcaadPqsGHO6EYarlk7ZzxhDpE
	ba6HkWXxT+HQ/WGnznTLktR0WwLcN1JcmNhFcaosM3gDEpRB8A5KYADfHq6Cv1fqWy2c69yD32BNF
	HIxMJrE3pboEI+CoGH9Hq50DmyzIwwXb+WMpuckSGdZJ/eGPyXr/sgtjV5h1B3y8/EIiL0sqaWl+s
	M36WrNJ7CaxN0V7mWdbPRsiPPZfdPlJXEOdf8uGlpj3TbIzZiBNkkCSanezMR53RnjBVmMRlpd02h
	uRmYf5CDNFbRFhOuvPXjkHFObR1VX/XuFqQ16y3tCWCf/L8GddrE1M5sttuTnJsg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vQ1Zf-0000000D35i-0PYH;
	Mon, 01 Dec 2025 11:56:07 +0100
Message-ID: <86d982368a85ab9dde17e52b45e77f5f76efea08.camel@sipsolutions.net>
Subject: Re: [PATCH v4 11/12] arch/um: don't initialize kasan if it's
 disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com, andreyknvl@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com,
 christophe.leroy@csgroup.eu, 	linux-um@lists.infradead.org
Date: Mon, 01 Dec 2025 11:56:05 +0100
In-Reply-To: <20251128033320.1349620-12-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
	 <20251128033320.1349620-12-bhe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3554C40012
X-Stat-Signature: c9c7swkqpb7kjfdu5qw7rgqnn79nu8p8
X-Rspam-User: 
X-HE-Tag: 1764586571-32
X-HE-Meta: U2FsdGVkX1+/lKb62wWEtqCIcPLJKic1y40WA03UgVk303joX5xFyNqx7rj4sVXxhvzxTahyh2sisCap/GNlR8YodTEeGFTnTtdIvQjePkeFgXXeA4rf/+kfaCPkov4o13hGksxyfxOmNCV6gJ0NJOGRnSFW0aXtt/qJ25zXtNYwU7PgTib3Z7hYto8rr2FTDfC0vTUolLPx6bjjmeKGmIXLIikHVpx3s/TOpdTBK7W11uSQ++X1h7kp/L4aMC31g1x8EnOCsi52EeHaE4l/xtYmlFTAb5CPbtGPg2ZWmzeIuPYUJwysN29aiUPBqDefjeEEyCG17E8UpAMqRG+XxJEQQZqg764B8i8YnkDtuYDhFZoTjUis0hH1k986gJkzBIePHdI7Fze6+y41950zp8gcbd+w2hsQPP6JM/u1PEVtFPJXqn08i4REGH4hw7mCMY1MoynW3rkm3bOBSQA1JLxD8mHGA77POKHOHrceHfBxMVJ3IWMg5kcmO+ztxUuoUe8oBsF27WA1H6f9Y+AZX3AuM6H12ecleQjtPRqNnYP7HYXrDkYc7HTZrx0B+0u5ktENB62nbEzZ59+ri75Mp1kR2W+WAYPYZ8DB1tu8CZX9qFlNuOxoAL8T8f/AcJRuxp81qs8EnsP4vbDODSM2QvbYHP08rDntIKJ5TOmTUgcsSGc0UZgUijX3yLojan0b9MK6Bhb7dkcw6rHRDS+aJVysr7q4WZvQubU7sUTgQRqOb0KBOVWRbmrwKGFFbcbUj5Lat/NEK4Xq0XBzuK2wf02OD2Wkc/3PdQMcyB3/o1XChl9IW2bquenm7+6KvGqUPMschc4zgz+FcdV1Q+HkLWHhGObdrZ5Wlz7cps2aYml4989ZlvjVvQs6Hy7osW6FpcgNcCdfWh8njpxCy/on1YxobjdwXDhS+NlNAHoBa2N64r2gqH/USxobZLgqHLioxGh9Q83A/ZKCvLtwX9U
 fvzPTlEn
 GoL0yzrS99ccuMRAuCbK0macAXSy5zEDsz0dNoIGVW9A5tNFM1isk06BJsCriXm6i2g4mqhP2FvuCeLxEM8YmIQ+d9yTqB/7mN9uilVPexd6SQQCZqOP76UuHYOURJU03uZRiYJEi4lvuAXF/RLFax18PtkbOzuEmsVdqGuGpor0LZBjwooLO+ISPBuQJ8QMRQmIXqdv2fWABD7Zk9jgaHv4abJY1BoVe4CNHd6Cg+7fEP5A9ym+3WTjttZtPCfbWcAbf5ief0TnwvecxZCPBINvPdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-11-28 at 11:33 +0800, Baoquan He wrote:
> And also do the kasan_arg_disabled chekcing before kasan_flag_enabled
                                     ^^^^^^^^

typo

> enabling to make sure kernel parameter kasan=3Don|off has been parsed.

But I'm not sure how to understand that sentence.

And I have no idea what to do with this patch, with it being random CC
of the middle of the series.

johannes

