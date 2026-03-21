Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4878109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136376B009E; Sat, 21 Mar 2026 13:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7A96B00A3; Sat, 21 Mar 2026 13:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1ED16B00D4; Sat, 21 Mar 2026 13:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE8EF6B009E
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:45:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D5111A0402
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:45:24 +0000 (UTC)
X-FDA: 84570796968.28.7D0C435
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 04E2F40006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:45:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2eggLpm4;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVGXH1SxJj8dD8zmZ+WAQEA2CbNwgUcMHntU25B5dXE=;
	b=EfwPFFW4QcqisuH+12thIVZ1eAw9bm3/gmoMd8ffOma05yZEvjugVEdZ1h0XRrxoF8kvDj
	8o2TyJuMiWlYA//QjPGyDvilUjITGNcPs1pa5Fp3W5hK+0wDgsjRRMl30TdDklNNjLdTEL
	roTpr9LtOPg6c880WHX9DavIOGGYELk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115123; a=rsa-sha256;
	cv=none;
	b=TTsEeB9wYt+o5DJQ9n/efT2nH/qQ7XROvxKqU50vwMBQ0QDalv7FTv8Y0T9zZR46I6nKZo
	GljY5xmbngjt2A/5Er1gSbx6PoTMn/tSB3/czY4KHC+2+eLru66qBRAjJgfWLnMv4Utjqp
	nPF0scmL0pPuN8WyF5bHIzm9Fab6OYk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2eggLpm4;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DD7960097;
	Sat, 21 Mar 2026 17:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C5FC19421;
	Sat, 21 Mar 2026 17:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774115122;
	bh=b09dUEiuJZvqLTVdlTgn9/rX1kYJB0cx3MYC05H7O18=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2eggLpm4YaEuXpxVeTrzh145/QggoL5VcJ7Mksr7anH6AU6oQX0s99X2FXLqL58iX
	 om12fFB7CnTxAzjmTikgUovArDr5gHs8ArW0BHReXqh7H0hse4uptdNR37FXj6kwup
	 UIXvqEdSPhk4fynERqS/2ahjE8n5unx08ZJOahZo=
Date: Sat, 21 Mar 2026 10:45:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport
 <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, Pratyush Yadav
 <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 1/5] liveupdate: block outgoing session updates
 during reboot
Message-Id: <20260321104520.5e9aa4768df0520d7d6588f4@linux-foundation.org>
In-Reply-To: <20260321143642.166313-1-oskar@gerlicz.space>
References: <20260321143642.166313-1-oskar@gerlicz.space>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04E2F40006
X-Stat-Signature: 63yijkkhjap76xz4rdfdpmiyszibuycn
X-HE-Tag: 1774115122-171859
X-HE-Meta: U2FsdGVkX1+aHzfrkEt57TZu0uti5h6AZxChaMEfUtPj1b+lWkpHitYUeMv+l0ll7PkbaMzeT9OlyJRcoF7WgDHOErLtF+jQqHBYiv62xvp92Wh4ltKpqHOd0iSQbNweuZBkpC/O6fu0c4w2djyGmQz+G7CFN9SwB4rEiPkWdi0PF/7pfMo0rWfnxmf5U7hE8nKRShGkd7EnOl/Xz1W4LDtG9PLBf48Rm2N3kduPk3wkC8U8Lv0q6RPZGUg8i0H0+HfLPf2POInizo63JSMGq9O+N7QBW6h+UqUUeFfyXr+WGBN6c1xcjjNU5u06QwWfYo3gtlUSkmibXFs0pd2kd6U51L39kgu9jLglh1gS53+oonMtwQ4cWdmxgy3j0Lw4qUc4fQc09lUAVg8l+y04EHEhl2gwGyz5mVMkL0WQds9OFsU3mq5UVIuwv3s7VFV2ZKU/FWPWb/RL0lASHZtk8AaBFuLK1L0YuiPMP1YNSEqNNm/06dGJPXoQ96KPn0wn1Xfmiv0c+XJniMR71g2YfRmU9iNpjXlbn+XrV4kb++Nu9kdwgqS7I0pvi0P5nytVk1hA/1YnH0aRmpSfEx5lwpkCHBtNiY6SjSPMaY75y4kOQigPXzrrlHPwjqa/sARLWov8iMRIRtzdkmcQuonR4iRqOh77c0VJjmIQUMt7nL1aorm1ci3SBKTubsmG8wVIxTbVIpJGKny+yognZUuSGBWMuKK7xMdgKqh1WtnfhmZRA5nbGpd//Yjf57Pvv50FonirwWMmaUBxwvwftEPudfs1W2drQfYbobQZx5tn/gxo6Gb7+mzLZPjbGOrYrGLLFOopAsHL3BlmMnMryosmLO4SkzJp2/45S4RPkRW3hxNe9tastcvF+I1HSq5CpQXERIuOdfBeQvclkEbAN2RenIuAt+dNY/Mc87YSSBaMEujXnGeQ2IojVxxIDuv8666bvLa7ZKQCRY5o+3wPaW6
 AsyMTQXd
 5GoHq4oVvODv29W1my60ZU2izdybLw+8ct587Z5BuKrZemu6P2EEih8RPcobZm/KqhqGJVDU9l22V5QHRxVxsz4pXVZickEnmCliP3uoWlZFK0D9f0zUO15vZh8ie1AV/dNzCHM9u/IkKWQOit/P/nZJgTC8NZqxK8loTI7FIxIjlq4Vnakf8QoDsX4s/03AvdnisE6oAOaLe/2hn/bHLIwp0w0ORCWiJgA2rqxKd0k/FcMZyW3HAIVhGi7zSR7BdDVa8Itsj6qoZ4f9egVE7454vL3v/HNv14PMhzvMFNhHWdr69eGbjwM9fPR/dTXTMpxkd25QnHGATqbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 15:36:38 +0100 Oskar Gerlicz Kowalczuk <oskar@gerlicz.space> wrote:

> kernel_kexec() serializes outgoing sessions before the reboot path
> freezes tasks, so close() and session ioctls can still mutate a
> session while handover state is being prepared. The original v2 code
> also let incoming lookups keep a bare session pointer after dropping
> the list lock.
> 
> That leaves two correctness problems in the reboot path: outgoing state
> can change after serialization starts, and incoming sessions can be
> freed while another thread still holds a pointer to them.
> 
> Add refcounted session lifetime management, track in-flight outgoing
> close() paths with an atomic closing counter, and make serialization
> wait for closing to drain before setting rebooting. Reject phase-invalid
> ioctls, keep incoming release on a common cleanup path, and make the
> release wait freezable without spinning.

A [0/N] cover letter would be appropriate.

Please have a think about which patches should be backported into
-stable kernels.  Possibly "none", given how new LUO is.

If there are any backportable patches, please ensure that they are at
the start-of-series, or separate them out into a separate series,
against current mainline.

AI review hasn't completed yet, but it has things to say:
	https://sashiko.dev/#/patchset/20260321143642.166313-1-oskar@gerlicz.space

