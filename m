Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52593CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC646B0098; Wed, 20 May 2026 11:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3D76B009B; Wed, 20 May 2026 11:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B185C6B009F; Wed, 20 May 2026 11:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A35DD6B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:09:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E68CCA0399
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:09:03 +0000 (UTC)
X-FDA: 84788130966.10.33BD8A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2A96F14001A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:09:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBNEgK0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289742; a=rsa-sha256;
	cv=none;
	b=S9+A84hbTXjIQspp8ZK8phYZbGk8a3S48Hb3dJvWH8ERIajE0NMFqiDVFT+8yH0RDBNdtV
	GUsyFq7wp/KzAXx7B+Bf2O4BiPNyj1sEyWFPJWg3onJoLF3KBP2simt3M4hMvhGluGO/pW
	vG/NagrKFS90Hjm0E4pNopBkeRMXCuQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBNEgK0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6aaG3Wi7U/mVXa+HoF3r7KpGIx6UgWdz+CiPn4ZY9Y=;
	b=moSeMmrzDhpUPhWi2T0nU314F68ZKipT6ltJXpGb/fyjcsJaUEbuOylC/LKnMp31UaDu0X
	/PlxGPf+UQUEWmxusBCwRkaGPiOMiwgHETIzfMxTaGeWHZQUdU70NTERGVRhh2yXlIx6lK
	vq7vO+BfToyGx8rbBoVeY8oQNwCE+BE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BC4D40AA2;
	Wed, 20 May 2026 15:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0991F000E9;
	Wed, 20 May 2026 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779289741;
	bh=+6aaG3Wi7U/mVXa+HoF3r7KpGIx6UgWdz+CiPn4ZY9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XBNEgK0Otq+pxHu4X+XF4f8pm/UuvAw5IXPE1DWDuTUrjMp5m8aQAgO+hoDp1CEJE
	 smLXooZR7WNMlLo9l8qKkE8JiBy4313xKu7VxNd65dvmdoB9x6XVH09+SweAubf2qY
	 bP3CD0McAjKLjlk0pMXad0V1ZNQ5YzFMr5+C9H+N2/R8oZWN/W7z/VzrWaTtpVcWFV
	 Om8bkIKrIgGHB8hF1oUeIToKWF0jNzttwmWIdVJ/7aKHVO5v8Drsrg6DwrCctfxG4E
	 ckW4RBpMi72Rm2GhMGakOCBVrJPaLeDJMf6G8o9mcapkyOh0xuAhH4Q5t79LtvB+w9
	 6J4dNhfN7bu+w==
Date: Wed, 20 May 2026 17:08:54 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past
 exit_mm()
Message-ID: <20260520-perplex-mauschelei-df8077fe4a84@brauner>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
X-Stat-Signature: ouds983zw9598yxg1bbngbkturw8w96c
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A96F14001A
X-Rspamd-Server: rspam07
X-HE-Tag: 1779289742-705211
X-HE-Meta: U2FsdGVkX19PMeULAPfFduqriEz1+iHEmWfKO/D6DlEmjT3ED/g7hyq1EUYYB4/s+ungpUi9QavU0SKwrQQTRbp1HZYSmNe887VWoWFsbtk/4Fx81dsLCWeczXCiQQBl0v91r7BXTIwMA7jS9bniFewXJwkCI9JnNFLw6nDJSW18MqsxH6Mn1A2x558gpd2qlFoXpK03zJhUqGifVeKqPe3gmPO52wS3XRjRhEJUuSwFrfEksZzJFXAw7UQXEMLUYNSGA2ucviW2EtTx1+uaK/uREwhljGeKskPYCibt4tmg/RWU9PwjM+xUBrpb4+TmYyYnPUR7CydEZhe2M2DX1h/SBJeAc91R6WO5LtlqLE7vCJhT8q1nK++1pgDAgwqaxns9HjGRbnWIyimcbaE6ePN6MGOcscea29gO6Y/q7Vl6LsBRqFCBWKjrmumOo1X8h1AVBkE13bK5dz47N2T2ORoXAhCVi8U5r9KAW5/z1lSdW7CdlFnowEiRQwI3ZjvOwcowJc3ylAQeE1UbwcsFvmGDHcqR7ZxXU2hCVM8qN9ZsdTfBWvs+/cyhY4NH2DQnzO9VE7ucCfscFWoQynG0pl5znYtkp8HgnTZ5jSUj7FrjG44nAqedIVd0tXgajyO3oRkLqtYlQnqZpyhhz0/ecpIdI/rpThYlRrGdcv8aS36OkNYY/vPucunj4dpZbIRhpg1yLIWRmOJVSgQet1bi1QIMeW5dU+7nt2dz88fq6Dl1uNx83Hp2msNfPgFW4k4VfPTcjEsRiXakyVka/V6VbDLxEdBEwpN2kcGA6E8/Vav18r4F429z+9bPGOXwjiXqoMYDPKKSt4Lbtb0tfa46HRfmtC2sCiGjHMdCmkjipKJxoTjmYw6tcPeD5mtdlw4f5zKvXIxtcYwTudqQ4GUVQTpNApFV0700alPLkVo8xPem1MmLObZ4oGizx0yefsD5ZAE4HX2sc0VI/Uq8wp6
 LHss1sWl
 YSyfu39RQrpQoS3phteRfuBLBPMLBHe3hveq+NYMSWrGnhpBl4QDEvV4MIPJpb8b8WDlx/Gwju9u/xY85V1HeKEPq6PZ3Nnnw0op4IkRWnKv69wodLFRMH6yTcIp+VOhSukM+v38BbeRvHGvAFemwlh+3Qf2i4ZDeQg30/idHRp5UtqGLv/msdZ7RX+UKqTAo4cA3JKBEPDzz9ezQNclWiaDNQM0gcgn2s8F7RxKRAn3zWbwHDIY1tfI4p6mR5tNtRGZ8Gji2E9m5YetqTtcKdeGSLdGvss/5Sg1cQnelvijBYnATdKmosw5kDOSwtc4sJsAVNLGgqH68SbWDVkB8LlOpbM5Xlpsvq6Qj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not the best title for the series fwiw. I thought I had fixed that.

