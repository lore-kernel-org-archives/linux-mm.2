Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B235C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00ED6B0092; Wed, 26 Aug 2026 11:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B546B0095; Wed, 26 Aug 2026 11:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7A06B0096; Wed, 26 Aug 2026 11:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0956B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:56:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AAB61C0693
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:56:10 +0000 (UTC)
X-FDA: 85143872100.13.AE4E009
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6918F1C000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:56:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VylVp4aL;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787759768;
	b=lI4aEpMzoEonJQ1N/HeuKlC6zm4eporusHpAd4i5cUOKJ18U3e+YS4cZKp9l3ej2GTjETW
	F/kL2uf+0P/T7ctet3ulxmcwtCTAHHXDb7j8TDjb6BVacJYSxcLGy+lO5ZIdWZ4tK2cpAa
	lARiw17/7ti4fpAxSoo3lIqyxH123b8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VylVp4aL;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787759768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKxxVO9WHJPVfrvijFU6xCamxUW5/MUbTlElGx2vOjw=;
	b=o1NnHR2SbFmpfKFAd3zhHZr+hBgqF3jdsHOQYmo5cifGpVov9aPqfovQpxM9St8kOL89oS
	YTabmih/kfo1zwKVOJduONYg08lAyBGZPE7fwY4+MlRu+gCQCiohuMYTnr/fvJop+tVtsh
	WCf6PZMpkWFvSsv0GgV8SYuOVlUwGxQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB52343E78;
	Wed, 26 Aug 2026 15:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A821F00A3D;
	Wed, 26 Aug 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787759767;
	bh=NKxxVO9WHJPVfrvijFU6xCamxUW5/MUbTlElGx2vOjw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VylVp4aLzoj6h2ekemVf7MQp3OCAp7cDjz3M/q4OACcXKDRYDvy3YTMSXZedvDHdk
	 Vj8aZNPn407fWGqDPrwGM3nrGyZi6UHLYS6F4M9SVn5fU3VuUQARqvk3l7Tu98y8X2
	 lWW4duh0K9e3dGo6vWEf/UN18MnESm/QDHE+CxpinZAh66x7MXKkah1PNv6fYLwyVX
	 Y/ghYYGhs+h/T+iVQoa9kiPdH9Ed97Q/eXh7k0OYFBhNb6CExRCy1aZ+0KTIl9ayZy
	 k69T7XjFVLHsN/vGElXQZgh6a6Rdh5nSSRkzAhimlSvxOG1sLMhdt/kJQ9bxxAZTuV
	 YaVDmFik2x6zg==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 26 Aug 2026 17:55:48 +0200
Subject: [PATCH 3/3] binfmt_misc: document the field delimiter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-work-binfmt_misc-delim-v1-3-43618adf8599@kernel.org>
References: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
In-Reply-To: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=894; i=brauner@kernel.org;
 h=from:subject:message-id; bh=PndQPAXcBeOaQi7lJUgei03fmhGSoQt6dZRbXT9rno4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT183RbnOWo0riQGX/MUCv02qU6Zu/ZgWYdP2tn9yraz
 l7hq3ymo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKr0hn+Vz/gnMhrvWk933OR
 GRZCL/TE+6UyHM17XXJm6k86cLs5nuF/cHefEaPzp6/5U3OYF51m/JO+5rPMhDCOOjavLkm+8zu
 5AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6918F1C000D
X-Stat-Signature: soxt6ahwomy1kzfb3qm57c664s1pajb5
X-HE-Tag: 1787759768-507800
X-HE-Meta: U2FsdGVkX1/toUAM2BJwooPHsCWdI04GBVHodnxGk/JCxgfwwl2QfaVd9lMF6b8pGziW00xWokHcZlu4wsrYXNtwqUTri2KuIR5Nybm8eD5jdXCCqp3GCwAtXGTSnQGbsXEzpzIIe3MLL8uezf9Cg/jLEBtScpmHHpHKm2Y82LmgNFF19+OGzxJQ12zBQVzSBoUdF1posrUZR0HH4SJwsuJz82qmYQC7bhU3HZ4niq8M6RiMd7ibdF2DCb8cjlMOCR7egCod2ipXeAOPEPR/D1HKrewN0vV1ii6Fkk/5Cw9XjFsC8OOH7T0h2ppJsFDCxBsSjB2SmZRE4dCq4nIursiPXupEbq3HOPXFCC8E/TTiwatTWmCGaixFnCPWjTOFr9ZHVcHLJe6CYCWWbn4Z3p72bQPydC8zfddaxry3yk/2P5suUJ3peDkysYYZ+B26m2VnOnrJ1VCmoYt3c/ZL2btzEz95TsXjDpSJagGg4m/XLobZNnhCifnwJaweKm0nSORh0MzNfEYAZSyITeKNFbXh+A9a2RjzvkacdlFl6B0d7gMOuSVOLn9ZnlgwbmnjAHoooDSObU2t4I4wc1hJP4OX2LUFD0eheACjmdbENH9vd0aOoraC383HEu45okICNgFWgGo2MCZJV7KLRKlFoPfw+1or82yKiIKkjGxT+G70zx5CyNPEPv0PAAXQDF/jrq4gwPPUyqmzWooOBbW13leLb19AzKEvOLyx42mIAcnwkg8bh4DM4qYrEiPDuc/d/4hqE71ARUbi4DlhZHNCHyPHK25K6gdt73F13XQ5Wtr+qQYFoQWTXvV16+V+OlbGPw5XcgKI3d6x/xWpWRcJt3NXTaO+Qw/H86QV3uEDRRbjfnyDoy4RjNd9/bgJ3A83W6WHWIc0hvrG3ANyXg5tBQx+xrHiWnyI0+bYKjTqw34Z/yvcDVHhoUSxnNuu7BGRIyr4jQEOdZBUotP9YRt
 NnvRiNa7
 BjtCg2vlpCi9roQ9i2UH4FibyUGk1+f9SsJH2ENBnByAVQuAd3eNHMelt0xAjtPaZWufvcbiueFKgNzeZ3zmyFMQRKu+pffCvEDqdxc7yOgByjuQqeG4AxHb5apfHJN3+0i/Siw6ReaNFNQdzJOZwKlYfCB4yPSfwWtGwQsGKd+l59lkAbhxxel5EQfrI2c45hCbabdXcLo3Etnn7H1jO5igmfQRYRr/i0e0FuKLmuPwp5Qv9nZ0NkmAWnVw7/j4/WUjcXjHPyY6oSKQyvx9jDzQRJ/t/QuJGit/oOKcdJQkdDkisJ34Gz0G5aAFH9jp4vjoz9xRXlSIXSb1cP2TLFLcSNvZ24HRh0w5wYHzHEJvtegc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the field delimiter.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index d26b63a27c25..9e84b877d06d 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -19,6 +19,9 @@ To actually register a new binary type, you have to set up a string looking like
 ``:name:type:offset:magic:mask:interpreter:flags`` (where you can choose the
 ``:`` upon your needs) and echo it to ``/proc/sys/fs/binfmt_misc/register``.
 
+The first character of the string is its field delimiter and can be any
+ASCII punctuation character other than the backslash ``\``.
+
 Here is what the fields mean:
 
 - ``name``

-- 
2.53.0


