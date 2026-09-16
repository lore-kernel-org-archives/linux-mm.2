Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C00CC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73CD66B0088; Wed, 16 Sep 2026 15:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDF46B008C; Wed, 16 Sep 2026 15:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCEB6B0092; Wed, 16 Sep 2026 15:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8396B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:48:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBFDFA0104
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:48:43 +0000 (UTC)
X-FDA: 85220662926.30.1B6A11A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5ACC120003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:48:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+TcsGVv;
	spf=pass (imf13.hostedemail.com: domain of mason@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mason@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789588122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lUJSxEgNohuUAfwQ6ykoq54FcKmmAc0TQEIhkx3s6I=;
	b=IfZFrrsXHHy5xvMwVVIp7naXqkzzcdi1qAJBwqIKJeM7lgxewEMdmjiyxAjXW04o04i5/K
	LQBmECjH6Hm0vFnNlzxgWVKsuag4Djfutd0uX6aO0/0m4BfekOxio/YEPZCLp1ZOGd88cS
	syMIa734KsEaewcFqLmbPYZMpsau4gg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789588122;
	b=qs7PA1uw1pv0L8XD6s9+l8MgwVm8qf1M71YmTC2vqE1PQk0zzsasA9Jb9B6LkNFcOl8BzW
	UYn0svCFLYmYyDPW0ImlWrIoS4/rr0V8Zk4rKLET94GWQdJETsnXtgcUY3FqQT2/q6rl0B
	Uc9rKZcfYVavUHpaMCGhsa8HaKizpgQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+TcsGVv;
	spf=pass (imf13.hostedemail.com: domain of mason@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mason@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A95246022C;
	Wed, 16 Sep 2026 19:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F031F000FF;
	Wed, 16 Sep 2026 19:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789588121;
	bh=7lUJSxEgNohuUAfwQ6ykoq54FcKmmAc0TQEIhkx3s6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+TcsGVvyTZUrzt4jNFU/fFzltaz3jcKlTCvOTDtO4Ct3FmuHHvRDBXQMWItqnbFA
	 9/1/aI+IQhhfYqtkR2wldq2H3fRmzhNPxNT+euOaJBpOU41PBbax6N5ErcxGjTMVAW
	 gESrX+MtDRgAU/lSLfx/LWR8/yoBWWLx60/Tz0D3A+yryguIXeS0gkX/C2leh7eAlJ
	 O09RuJaQ3K2i+o4TYwM73wlm4sAnr9sX12wQDYe2pWH6mmcqy/w6vOIdpXjFretJev
	 cQjdcTDwGpn4LgRbdXviWzGuU3yd+Q96Laz8dceamz1pv1/PhB8FxVrLIiI4UsPLf3
	 VQfpe33Q9cQ7A==
From: Chris Mason <mason@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-mm@kvack.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH 1/6] coredump: don't switch a dumper that has no files table
Date: Wed, 16 Sep 2026 19:48:34 +0000
Message-ID: <20260916194837.3732307-1-mason@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kp75cbg3g7mwyhxgu6bnmc1s7ob7kcp5
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ACC120003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789588122-344786
X-HE-Meta: U2FsdGVkX1+JzKq4T3sNJSKe+ocw+drLdFJAeqsYl/oRSsRR82m98qXRLrBWiIKV/DX+z+gjQ1kWaMoSzkpeLsvuN27OSd2+5UP7rggDTQ9bY4sidLIV5n2TMVosvR87xEhm0WkaD3cUXbx5GeGkM0u2AkbMFC6Y90DfIwoEEX8y8uI8iMIp19xjUPMslSuGEEs7gwTHrcXJAvqr62c4VMjd+Tq5evKNxktZ19gLriF0if6E9BAuEq/yY+TVwTKHYXOW6OmZXooZuTUS1uMxVJICN+ZX04tDW/fy2lTpHxD16bnzchYZ59ogBozB5hbNc6qGXKacnI47Mx3UPC0FOfGDcFty35C/abJMGIafHngOolezIqmSjAMHmTXWWto77M2KS0y7XLvklCkyyyTCowgbsWaV42BFIzOzDM+6NBy7abRpkFDiYsndp1LZqYok6+r3bC3f7Ni7BxrfJnUUxVbOmjnuLc/uubDl9BGlfQ4P/vpc5pNuyRPcNpoCx5QcbwzbW+bRDSVU7IxeQoFfQWhvS22gk7QeILAf0B0M6nO5wrjCIbEuapBL7xXchVQFMFKntOa45Mr0rZtbxMlPqxpnZDmZ3YpiKLpkz1ofD4S9WCxXU+7FRHkVmCSVoYIRohzmtqKVbfu5FlzniCJWL/jPChEIsgYzMUlDByXJ8TUaSMlN8JuNWOo3/VSyuEokTp5iJffj+D8+ozfcOa/J/rKpIDQnn/ijL0yQBKScKXb6boMXwVr5W3X7CjfasdZ+dYQCiprpA62wkyo7Egz9xP5zvb6xBeJxYTWVZ0x09WwVVD4aXHySss2dOOPXtXxtzZwD+DjmiNuREBlZ+Ua2lK+CboAcAB9pAEyVQQt0YlArBqTKmsbC/wswAsNL/PE3vOVMQAYd0JETr/ut1Xy0bTS+0kXiwQAecM2QRAipNF8cNDQ3b/PbhP3jkx4XEcnujbq+S1QOGvMJhDLgTIs
 gu064fTM
 BL8N2IBmD6yRIOx6Z5F9ldIbXxQCYn0NDHNxvHH0mVn3KzjQ+gCfjX9+GhpAnGHyP4VctudyS5aAVLoMYGdcMaPcyeao5VJDrDQfLVOhxQNyL84ZxTpxP0M3o7YIU7viS8Or4lP1Nl6rWQJLeT6Nk2COuQ+xeUDwP0X6u5vAERSj3f4+Arpj2+3Q9DNZx3iEmSrlfFX/rhewPiQI+C8a2rkm69NX9U4HfcMBMtSLp3hIRddo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 12:22:16 +0200 Christian Brauner <brauner@kernel.org> wrote:

> Tasks without an fdtable are skipped in coredump_close_files(). The
> coredump client itself doesn't use the same check. Since
> put_files_struct() doesn't tolerate NULL it will oops for such tasks
> without an fdtable. The prime suspect for this behavior are vhost
> workers. Skip the switch for a coredump client without a table.
>
> Fixes: b2b36bcb13ea ("coredump: add COREDUMP_CLOSE_FILES")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/coredump.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 1fba3fed1a07..791a9268ed96 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -579,7 +579,11 @@ static bool coredump_close_files(struct core_state *core_state)
>  	/* Use the dumper's real creds not the overridden ones. */
>  	scoped_with_creds(current_real_cred()) {
>  		io_uring_task_cancel();
> -		switch_files_struct(current, files);
> +		/* The dumper itself may be a vhost worker without a table. */
> +		if (current->files)
> +			switch_files_struct(current, files);
> +		else
> +			put_files_struct(files);
>  	}
>
>  	coredump_wait_inactive(core_state);

When I reproduced this one, it ended up deadlocking with the fix applied.

vhost worker (the dumper)          sibling thread
=========================          ==============
get_signal() -> vfs_coredump()
  coredump_close_files()
    hands sibling a new table ---> switch_files_struct()
    coredump_wait_inactive()         put_files_struct(old table)
      waits for sibling's switch       last close of the vhost fd
                                     vhost_net_release()
                                       __vhost_worker_flush(): waits

AI suggests making the vhost thread requeue the signal for someone more
suitable?

-chris

