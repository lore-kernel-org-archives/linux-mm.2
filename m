Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 171A5C55171
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 22:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09336B0088; Fri, 31 Jul 2026 18:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0A76B008A; Fri, 31 Jul 2026 18:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D29A6B008C; Fri, 31 Jul 2026 18:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75AD16B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:50:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B6581A01C4
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:50:32 +0000 (UTC)
X-FDA: 85050567504.05.5D0E9D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 046FCA0006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:50:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XpybBdrH;
	spf=pass (imf25.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785538230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZw1uJeWlziOlVI9DOasLW5M6YgVtL86SJ1TJXlW8bE=;
	b=P+/Lr5Fb3RXp3AoNy2vyCr14QdWgyQ3ARY7ko1dU1VjrSCvKeAGk+1lbrqKc7wUA+NggYm
	9wCXhuqyD73gTEVzxNxAOCZPXvjGg4WZDKEGagEl8oYVp5qCLcFcftrgiNVXF5AEjzCW7+
	noJy93D7GnqSF87IQBxGLfdyFeJXNEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785538230;
	b=FNYWR0NfZLOcIlm57YK0H7ywqhLwqN9a7cFZCESJukzCgPG6LbqMEKFnZ+J7Vw3pwAd+Zy
	1kk28cLCvtX3RIycQ8hujnOeYeOMlM2Azwf5qxoyoQHz/NTApeYVpeCu/06NmuX7V/16fB
	dNayOE0VhpFBS8mhMjZb6U3dkwFPVaU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XpybBdrH;
	spf=pass (imf25.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785538229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zZw1uJeWlziOlVI9DOasLW5M6YgVtL86SJ1TJXlW8bE=;
	b=XpybBdrHzhD9VpuVhK0FC09bOiMYy7b72sJNwtw3fMODQ+H4YHpgwo8Qs7Z7YHg8w2D8si
	7QVxGBBa4ImvrKmM29hzVY8IG+JpS98S86MgesYWSqQyEDyrIoI0QiZqfzAW4fjMJMYyFh
	HMwePDcxL2rlISsqx6wHuN8AP+FWBWs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-VV8sh2vANt2sPgB_nemP3A-1; Fri,
 31 Jul 2026 18:50:25 -0400
X-MC-Unique: VV8sh2vANt2sPgB_nemP3A-1
X-Mimecast-MFC-AGG-ID: VV8sh2vANt2sPgB_nemP3A_1785538222
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E04E3180048E;
	Fri, 31 Jul 2026 22:50:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.44])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD1A01956044;
	Fri, 31 Jul 2026 22:50:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260731154608.153258-5-linux@jaseg.de>
References: <20260731154608.153258-5-linux@jaseg.de> <20260731154608.153258-1-linux@jaseg.de>
To: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	"devicetree@vger.kernel.org"@kvack.org,
	"linux-kernel@vger.kernel.org"@kvack.org,
	"kexec@lists.infradead.org"@kvack.org,
	"keyrings@vger.kernel.org"@kvack.org, "linux-mm@kvack.org"@kvack.org,
	"linux-security-module@vger.kernel.org"@kvack.org,
	"linux-integrity@vger.kernel.org"@kvack.org
Subject: Re: [PATCH 4/4] security/keys: zeroize key payloads before kdump
MIME-Version: 1.0
Date: Fri, 31 Jul 2026 23:50:11 +0100
Message-ID: <2259835.1785538211@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: YLHyiltgyqVksbruKM4yoXj5-vsN3JnccJxF7N-I8n4_1785538222
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2259834.1785538210.1@warthog.procyon.org.uk>
X-Stat-Signature: hsn4dzx1jp5g54jf6bmhb6pt3fosugr6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 046FCA0006
X-HE-Tag: 1785538229-568465
X-HE-Meta: U2FsdGVkX1+ABVj+TnWSuKTiDfECKHOSx6RU52Lx4AANFixrVteaoF9D962hIxd5zLzKLqtaH4F1lzdwPbf50HWGq3XWwH9gAM34d72o3UnbY6qNYZuDcZrBcUX08GirTiHd6dmwLJ29rWSvBwwMANL19Eaqy4WIiP4f81tWJqfC0KDB+JP2mG10KrlFJhPSLhMv9pOBK5XUjXmgoJc5cuHvaG0XjIa6VXzsKKE2EqTqLbGjZZ6tMfDRhpA56HjLet9wFw1HFgKTdXDTOPHYkpPfWrMjTa2itOIzmmb8fZ/ByQpglZClFmJd9mrfoNP2LddCDI1i8e4m1RKqlMt8zRU+3nDiSVDoXnTSTy0niqJQLcPIsp0vt/cDsc97PICy2qMtnWImfWAb9R4zXIm6OpMxeczZNX8HwSun2sa2trfrslspyQU8oi74wrvbtNk9dWdPgzQqLnK+2vhS1mPe1oyxNkQk3TFpqoWKF+LRu5kUDDnJebmvNxw/CSFWa5me/TxAKtEpe1PmBR0S7E9ONS33/kEox0omG4wRtjKbM9GANhHzSsWPtbSR+g3tuXwKDokF4BJY2S3R5iFrGi+hgrnNf2qSZ8aYqLyoVlzxgoQtow5UxMXNCBP3c1fA/tkpvxedssLvrQ5fV/wp2Oi+bdCQWhArqRh05FWySubRl+uiGScw0U0NDH7+PwpllTd2sPwBmUw09JqyFD+iSzbkFEPfhn0pMT9mRJCkXMuyoMoqEO1CgoDMkvyzSaQ2dLoIccCAdFhQTM20IWESYvqvFc/ageY4BtasfClG+MqyQsQPKzN4GBtEmLrmGKCjxjjYVjvYkgxI9UxiuSMpNcGDFoEghmEi0HMdwgM5SwRnV5OsKhHUmfRSpmFshCAewYKTQYGSw6yAjbYwnm51r5D8LBs2rzSpqXg0Xe939x5jD83bD1VBFeLzhyV87X8EaLWn+tJcZ5/gkh34fJMnYVo
 g32tR7FN
 YPBIobnzlaqrIhOh3bQs7nTysYRMi4dFfKuC70GVKzf7pzShkXh1GXcma39FIN3WvZUbzSzPnf7FQah34a+T6bnpJ0vl6QYVD7DLxB8y2Cm9sZCL93FWH6haCJDsGBbgkmDDMkkeU3yc8QUdXZNhT7SE+8kpgUjTjDbzcL7036rVBbeR3/c4wh511/qN7ShQDLLapOSEkch5ZOienNNY1D7v4v0+N4zPrnlZ2ztkNbnv815OSk5VJYS1qaZg3LUHDzWU4l4oTkBgNFuvCQc6i9Rk6/8NecF94tkIBn+oInnLaS4hV4D3JLVjJu4xZKalCcLgAzx9fKPBkyYXWDGFUj9F9zWhoeyj7iPV2gUtTQg5mAupyRRj78GQg1FoojqhenF8xKxrlPXyrKlGynwaBTMQZs5TncGZz7GUOes6xtOZ+OVwWLRZDdnRcsEk3g36GYwEZFGPU/oueiVVvHQ3cJSCp0LrMU6Ug/LYQg/KtHgpd8Vsk7hKIQpxKSrFlPn2A9+9vdS99zPyimcdD0a+3tszbWFRHVkw/g+lOlipktJfZRZEIG9w7HMewdiB5F50VfM2euMabUvfSfCz5jwA1RY/1QSjWtH6az8HaTsvH48HCVoEkUNdRGcsvomezuwQF+Dv2bJ1jz7xIbjqQgFo5C3Cefy2cr2v8rkO8KNw4C18TqVpEA2SzgWX52VBa/1zKIIuIWlEUvJVazPd2gsVsKmwjZrXS9Zp25dHwVKC7L+3kIkNZ6a194GJ7Zf9EUb5fRiK3aEfer8YII88d+pP8pw+qjaPLreJsWRflfuMn0GEv5clavNO03N02+WrgjilWwvYrTaoqZ9BIsy9VgyEsqlZ3aQDM9TNbn8w59+7JYQlfpfFsfX9jUPYfqPNBa+gZ0Mm70VAFzWrqfgclPLkOUioVr17RQRLnSZDf0dZt5Cv3vevNFS3M9iGzv/wkxHRLpZX94lvxRCej4GX02lPqUUQ3MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've no particular objection to this, though I'd prefer the name 'wipe' to
'zeroize'.

You should also wipe fscrypt, tls, rxrpc*, ceph and cifs spnego type keys and
maybe asymmetric type keys.

David


