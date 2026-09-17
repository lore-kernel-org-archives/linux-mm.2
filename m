Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F7EEC982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 01:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726E16B008A; Wed, 16 Sep 2026 21:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9266B008C; Wed, 16 Sep 2026 21:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8556B0092; Wed, 16 Sep 2026 21:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 231016B008A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:51:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10795401E5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:51:27 +0000 (UTC)
X-FDA: 85221577014.03.4ECB8C9
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf03.hostedemail.com (Postfix) with ESMTP id F04A520002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:51:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=NKltVacC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="w qpyXN3";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf03.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.154 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=NKltVacC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="w qpyXN3";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf03.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.154 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789609885;
	b=vVQc3TqF2NuVpP92qC6DgMUUe4gUqGXZuO17F2YuJOty7JVU99JQre9v+aMWp0v5KOBMXb
	Qk/+RZmdJ7QD/aLOMgqFEdtz1bxYaoIqRdpbiFYqxVUklDaWkKDExZyB4ZidY9TdGHlP2u
	1vNKFLwFWDz9rtcMpPczhwJMkTnS4a4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789609885;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxDjgtURUrYLXWuVmthOY/8nBxAdySxpDJXUwnjUFWU=;
	b=JlXsPY926R7JbkjTavCIxIU07lqKKsYv8sjRpZFe8hn8spPHIsORmSkFvRsczKmQ79EkR1
	uAshDkRAnPcXN+hkxtSzmUJ7kHXFaJjkkZ7LlhwyluE/GhlZhumDyQD1OKciLARLFuqE4Z
	rAZiA+S/Ff16SRsoxeZHYwti/qHUvTQ=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B549D7A003F;
	Wed, 16 Sep 2026 21:51:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 16 Sep 2026 21:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1789609882; x=1789696282; bh=xxDjgtURUrYLXWuVmthOY/8nBxAdySxpDJX
	UwnjUFWU=; b=NKltVacCqkyNFITZDmhFKeDOqaPB+wpAQxxCpIx6b7kRYx5Ndz+
	RayAqd2dARzEpvsoqkNYW686ZPUCylpjjUKi8HwPd4LlezTZc+piCpYrI3kp35B1
	HaToMHQkyUx9v9ZfCy+vj2ijVXKWhdPzH1lp5titEvaz7hP2NMetfcc244+iPHaH
	MkPM/5GdW9PBHGspyBnaIL+szWyqSI65qw0oEoKebXKMjeY14b/dL5N6XBnxWAgt
	u7jop0pN3vVIN5wbVLWY7VJWZgmTaZZbZ/SLMiz1Z0C1vgfOZZLdjcVxKMg+eq82
	6VnoZxIQFwxFpirqzu4Hm0kXktL/w6XXgCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789609882; x=
	1789696282; bh=xxDjgtURUrYLXWuVmthOY/8nBxAdySxpDJXUwnjUFWU=; b=w
	qpyXN3mVBS/nvZfs2jm2m6/eDF1ttE11T94ywgwZDccSCljKxj1isOJqd2m+ury0
	mFP5+rNNNlVvbg8FQjqA4GGaH4zWMGGTZ1A4xQcPRWTfNQnizntlbMKOya9fSg2W
	qD3mqzmLO5KUmgubDLj2J64LlGoUgwF45Wet+q2BmdqZVeluaBuJ/o5Fzb0E5A/r
	aCK0QAKysScVJs6aEZfuiCrrxDXdyOEtOOqaTc9d4I6GRc7z2Yy6Usv93+smIrNQ
	Z9RmDRdDnNRrDCVBtQZMm/vkb87mah+ANcmnDDUcEmeW3r8zz7qJE3xeInMvviiA
	Bi5XAGwQBiFsszWZd1YxQ==
X-ME-Sender: <xms:mUerauqC3qHkdyj4_fx8xFrY0TkRSyqJLrwx02xmsVUUTvwxT7jW0g>
    <xme:mUeraodkRS6YY4f5DqETeSvJY7uZ2eKQKOZCl-FZ6d-Ogk5aa9oiEdT39zsH8zp0O
    XBI6n7M9uviesaQOWbnZfgiXAJyBqMbDdwwJ_1qgH53_Po3iN0>
X-ME-Received: <xmr:mUeraulQopIoiorPP2dZkfhAfWhaL6ic1p3qq7tu9g3R_Wv4dXEFmbw7YxM-URRnMTBG0A2Nh3q2aALt-fiYRticZ7J2_Gg>
X-ME-Proxy-Cause: dmFkZTGkmOHunoqci/9FHiPfgcqwnWwz8WK2A0uF7GAvuC3rnWYoxyQgQ/RdKNab/feNWO
    MS2S57uSwbA1/qtw487tuoXeVZmGDJXP36KC6ndxBdGSo3p/lMAmNl6E/wM1EWA8knyNep
    0ZqPpulichB29V3OLf7WsPAZ+yWIHV58qJtZfhBjDyQotLKCxeWxQ17FGAomE8V4engW2Y
    8mO9MbWKMPMYMBkp7FeiEYtsCKWdZhrkz8shM1SQ7Sw0KjQuTSkRco+s/O0tyLzG+wDtir
    NNDKkLO5UuJO3IGalqxbxGBuWzcEZSKxXexPvYZKLL819nRuJT4k9cy4z+KhEKcbh0Yqtq
    KJeiK3mEEXHUI9qQlB2DZs1L2QZ6bWzyxqgu+kG/3GMJeVvHCYtnyEMSryqgU9C2cFZTnD
    OvuDexf5cXfokYOyCYxQuRH7Hy221FXiBp3kZLa3bq9j6Psh2W8rhDgdVfC57sLcgx/H9f
    HSr/4WXYGr7pq43OT1qmsZvsVWrl8ErXkOj6OMn1C6ZJnJC96nkzgLlIJUZFwqez8J/EYO
    ygh21PtIB2jofdXaik/kWPHe2ET3YY97+z6VkRSov6PPvSnb/90OTR5ErgLIeUxFwNpmx6
    h83aQQL//hHaGgQ5wlkazZDHSkq1igTn5gTUdY9QchxfYJPTTQcmVoe0c1gA
X-ME-Proxy: <xmx:mUeranYGSBtmmGPx3_yjmWNMCsAgsGE0asck9eV4svtsaNDT3u2FVA>
    <xmx:mUerar5ay-IliCnCbTjzjovbm8HjiMYZ-oW7DNK0aXZqquVmB2IL-A>
    <xmx:mUerapAoQ9pBW7IMjiYWrLLBwyxYoV3Xoe7nkbeT891salLDLeKlAg>
    <xmx:mUerah-zYlOuGeNGB4jmvLWryrbwcCksG8ipV-uakVAyyfmHmpa-Gg>
    <xmx:mkerajuEcI_6izq20eKwQaKHHYUlRaqNGF7Rl2hHFtH0CMAU2MPCyyhd>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 21:51:18 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Chris Mason" <mason@kernel.org>, "Oleg Nesterov" <oleg@redhat.com>,
 "Jens Axboe" <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 "Ingo Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>,
 linux-mm@kvack.org, io-uring@vger.kernel.org
Subject:
 Re: [PATCH 1/6] coredump: don't switch a dumper that has no files table
In-reply-to: <20260917-staunen-sparsam-infusion-83238c68d21f@brauner>
References: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
  <20260916194837.3732307-1-mason@kernel.org>
  <20260917-staunen-sparsam-infusion-83238c68d21f@brauner>
Date: Thu, 17 Sep 2026 11:51:14 +1000
Message-id: <178960987412.207413.3957049392884487413@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: F04A520002
X-Stat-Signature: 1tjb1efmo5kyo7mpe8dt1j8f5kc5g5p6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789609884-355597
X-HE-Meta: U2FsdGVkX18LP2KUv9QtMLqB4OWksYI6mO4fwyj75xBfQ5h8zssutIprwRUVKQincQavEu+1PHsAVeMgCrpOISXBvV9aLkaPBiLX9YK1RgWBM9rsDpv15twlCfkJsRlkPsU4dnVJSDQASrSzvo9kAQcZJnPgzBG+DvjooJSiBRFVKRpIWKnG9ANnLe+qQURIhO5U3TVoUifFfHgpRIGdauLS7/YIG5CyuGahfvzaerRtwr+BA5LIEtq+nRSOMdrRuyvwf8UuiIrVcEu7wyFmfTvNlc3Muzot8QKA+eP+hSUTn7ERUbcHJpbCDxM7DzPoNxIfPKk9YN8AlbrO0zQHQwL48wSFlE9sNoN0PdTyCUu218uIXQjdcUYTPER5YQ+1Hl9WMr6NJWjuHFrdrEe/Ct5ZCRb55iQF+csHX2QQYtfBo1b4Qz1bkIU2mAOL8PP+noZRlkqS625vhiUK64fpUbrFXioPT15X7iugOhhS3WF9WZ8Vbk2nOniZUUpsDJXeS+3rxYhFRUjl7MUJdBje9D4tMKvF9ntC3QRT1oPDZRbnzm7HST+2H9mCUlSF04AnG1T0KZGqr7DM/goJnmS4vmpZaryXNNJrfBK7vkBexZK4/zgEux3Kjt5gtkTnmOnog89J4Ehk4zr/UE2oT/5lgEwJ9rMD1CndWxKDjIPXbSoYa3KqAM49daph1eD4GO2qSpJXhaTMiLqRVij0qDxUNHNz+jWsm3V72bxnZjKPEtMadkRWtknsiLeHrlLoWrqTHAUrICxKoBUHAiOwKa/N63Y1JNiENuuvC1+s091p6WRflSNa4AFYNWetAo4OumTKEaZHdGZ9VfAi6kGPnj2rD2EdxBMQE861JhDKjdurlH+U+e18bZzoL/hd7vTugpRVgBw1ngHsOlfCZ3/f3R3YQj74Hjna9NtoFgztLxZwtuiVNEv67FXzCTsSQHp2I90peDSPVSwttV5riJ/zbKy
 3foCTyHN
 MA8bPT1uaqbag9zSu+nM5pEi6v6MUJ/MrUtGqhpwZICnUt5wJ3YaYEr6ey1uhTAyVBoVVxaZKch1c2uHmjePSZ+WaTTtLuHe5ecwUYcw8vHmnhXN9lncZaIYtivNOz+XgxoE6+5E72IxqU3JV4L/L1Aa7KAZgYRedrPS1qjl7ceJ7ANoZYvegE0zLM7qq9zmcZfppm6hl5J/8/TB/uR8AOTRMLxYrEDterbca8oH9Ij6F/Y8Rxdzw7FX+XEsK6siGg46vHfT3SxNeoKX1qdVuWo+6xqiTRkJARSGXNSwvdXCC+KmW/XzqcZC8YOweZtspLAesFtZf2GMydD4q4NyzTDwxmxp/aTbH+PYsd/yB9n4dyLakAwpJNa/33mwXR2+Ij7vBQJVc/xh/Y6lE11fjQk0iOcLipRBMru9MneQL8bX5llzSuSJb/2KJYbiSYfZBA/hclmxDyuWhNaAiNCEHrelsaLrhuYkhUuiz3cwQZCGNXKJNUezUdvbH+GfMrDpKda543smovQdusozWR0/llJjoH4vFNV5fGYv0cclfS8RQJ0c+6XqjcNNswzm4ng4oCMLV0riSHUqN4nxm/g+xILlmGO1C9kCPIY+3xsby6hJiUGfaLOcv7XtPSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026, Christian Brauner wrote:
> > When I reproduced this one, it ended up deadlocking with the fix applied.
> >=20
> > vhost worker (the dumper)          sibling thread
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D          =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > get_signal() -> vfs_coredump()
> >   coredump_close_files()
> >     hands sibling a new table ---> switch_files_struct()
> >     coredump_wait_inactive()         put_files_struct(old table)
> >       waits for sibling's switch       last close of the vhost fd
> >                                      vhost_net_release()
> >                                        __vhost_worker_flush(): waits
> >=20
> > AI suggests making the vhost thread requeue the signal for someone more
> > suitable?
>=20
> Afaict, this is conceptually a generic problem with letting coredump
> close files for any type of user worker where the worker is the dumper
> and the sibling thread closes the fd that causes it to be stopped and
> waits for it to exit. So this needs thinking and we should drop coredump
> closing files for now.
>=20

It appears to me that there is already infrastructure in place to handle
the generic problem.  vhost_task has a "handle_sigkill" function which
cleans up on sig kill so that siblings won't keep waiting for it.
get_signal() detects PF_USER_WORKER tasks and lets them complete
normally rather than aborting them, so that handle_sigkill can be called.

So the problem is "simply" an ordering problem. vfs_coredump() closes
files before handle_sigkill can run.
Maybe handle_sigkill() could be passed to (a version of) get_signal(),
or maybe get_signal() could indicate to the PF_USER_WORKER caller that
vfs_coredump() still needs to be run.

NeilBrown

Possibly something like this completely untested patch, though maybe
io_uring should use the new interface too.

diff --git a/include/linux/signal.h b/include/linux/signal.h
index f19816832f05..def89bac90e3 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -291,6 +291,8 @@ extern void __set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
=20
 extern bool get_signal(struct ksignal *ksig);
+extern int get_signal_nocore(struct ksignal *ksig);
+extern void get_signal_complete(struct ksignal *ksig, int signr);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping=
);
 extern void exit_signals(struct task_struct *tsk);
 extern void kernel_sigaction(int, __sighandler_t);
diff --git a/kernel/signal.c b/kernel/signal.c
index ec30550951ec..ab8e0207f079 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2812,7 +2812,7 @@ static void hide_si_addr_tag_bits(struct ksignal *ksig)
 	}
 }
=20
-bool get_signal(struct ksignal *ksig)
+int get_signal_nocore(struct ksignal *ksig)
 {
 	struct sighand_struct *sighand =3D current->sighand;
 	struct signal_struct *signal =3D current->signal;
@@ -2823,10 +2823,10 @@ bool get_signal(struct ksignal *ksig)
 		task_work_run();
=20
 	if (!task_sigpending(current))
-		return false;
+		return 0;
=20
 	if (unlikely(uprobe_deny_signal()))
-		return false;
+		return 0;
=20
 	/*
 	 * Do this once, we can't return to user-mode if freezing() =3D=3D T.
@@ -3021,21 +3021,6 @@ bool get_signal(struct ksignal *ksig)
 		 */
 		current->flags |=3D PF_SIGNALED;
=20
-		if (sig_kernel_coredump(signr)) {
-			if (print_fatal_signals)
-				print_fatal_signal(signr);
-			proc_coredump_connector(current);
-			/*
-			 * If it was able to dump core, this kills all
-			 * other threads in the group and synchronizes with
-			 * their demise.  If we lost the race with another
-			 * thread getting here, it set group_exit_code
-			 * first and our do_group_exit call below will use
-			 * that value and ignore the one we pass it.
-			 */
-			vfs_coredump(&ksig->info);
-		}
-
 		/*
 		 * PF_USER_WORKER threads will catch and exit on fatal signals
 		 * themselves. They have cleanup that must be performed, so we
@@ -3058,6 +3043,38 @@ bool get_signal(struct ksignal *ksig)
 	if (signr && !(ksig->ka.sa.sa_flags & SA_EXPOSE_TAGBITS))
 		hide_si_addr_tag_bits(ksig);
 out:
+	return signr;
+}
+
+void get_signal_complete(struct ksignal *ksig, int signr)
+{
+	if (!(current->flags & PF_SIGNALED))
+		return;
+
+	if (sig_kernel_coredump(signr)) {
+		if (print_fatal_signals)
+			print_fatal_signal(signr);
+		proc_coredump_connector(current);
+		/*
+		 * If it was able to dump core, this kills all
+		 * other threads in the group and synchronizes with
+		 * their demise.  If we lost the race with another
+		 * thread getting here, it set group_exit_code
+		 * first and our do_group_exit call below will use
+		 * that value and ignore the one we pass it.
+		 */
+		vfs_coredump(&ksig->info);
+	}
+	do_group_exit(signr);
+	/* NOTREACHED */
+}
+
+bool get_signal(struct ksignal *ksig)
+{
+	int signr =3D get_signal_nocore(ksig);
+
+	if (signr)
+		get_signal_complete(ksig, signr);
 	return signr > 0;
 }
=20
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 3717885a5992..8bdf5b55f419 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -27,14 +27,15 @@ struct vhost_task {
 static int vhost_task_fn(void *data)
 {
 	struct vhost_task *vtsk =3D data;
+	struct ksignal ksig;
+	int signr =3D 0;
=20
 	for (;;) {
 		bool did_work;
=20
 		if (signal_pending(current)) {
-			struct ksignal ksig;
-
-			if (get_signal(&ksig))
+			signr =3D get_signal_nocore(&ksig);
+			if (signr)
 				break;
 		}
=20
@@ -64,6 +65,8 @@ static int vhost_task_fn(void *data)
 	mutex_unlock(&vtsk->exit_mutex);
 	complete(&vtsk->exited);
=20
+	if (signr)
+		get_signal_complete(&ksig, signr);
 	do_exit(0);
 }
=20

