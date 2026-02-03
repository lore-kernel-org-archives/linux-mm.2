Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BFAE87844
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 15:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514DA6B00A3; Tue,  3 Feb 2026 10:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF2A6B00A4; Tue,  3 Feb 2026 10:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5846B00A6; Tue,  3 Feb 2026 10:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA196B00A3
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:56:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF7B9160540
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 15:56:37 +0000 (UTC)
X-FDA: 84403598034.06.3946DE7
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf07.hostedemail.com (Postfix) with ESMTP id 911B24000E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 15:56:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=ZkigJbUQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="O JWb7E3";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.153 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770134195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVp/m1Quz3BoFMxHOwcVsiCA1igA849JUDKjUESuUCI=;
	b=c8g3roR19YwBf5aFfQalxomPT4s77iP4ooukHzIAtmaVirs4idt1XLqdiRKdTJwVg+/zhq
	0O9kQI9utrPxFWX0ZEiCYfltnBV0HHT0oeI4s9kYoRWIXVy3cg/a5yi8i6MGFOdNHuz8c4
	NyBnCvid2yTUFB0O4b9BErAOshEfX/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770134195; a=rsa-sha256;
	cv=none;
	b=t8O5eC5b05gILY3CUeFfgbDrmQyhVHGyADXBvdAVJiNmlDgtqYMvMyl2P/ZWDSK0zlPZYE
	TLUBESJBNYidQe3eE1nkEW8/vZIKyx37S68al4ULEWY7KBDJVxXqRPeNjo8STcoEWKonSz
	iiKQ/uZkuuM2Xxu6/9hTCy7doFAw9ic=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=ZkigJbUQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="O JWb7E3";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.153 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D18621400059;
	Tue,  3 Feb 2026 10:56:34 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 03 Feb 2026 10:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770134194;
	 x=1770220594; bh=wVp/m1Quz3BoFMxHOwcVsiCA1igA849JUDKjUESuUCI=; b=
	ZkigJbUQi4lP2PCPoPAYTUKlHopRZ0YwnspaEMVQfBCMEXpsJN6be9HBLUK/Jwh7
	8u+NDDjFVJ+GXyzCTtK/hGgtPwjK4uEajv0Q5aT4Co+Ox7IANF2kHag3h1TNqJOm
	/v4RZsFVY9peFJqNzmmlCDmch9lSVrIzXOZbakfcrSUlyPlpmr70aM3zaldLRoEx
	56pMN76Xrx444kUFJRayqLz6lxKn9wHzo4lsB8ulEtPi6cQ5kpe9QCq1gUJQdAeK
	LoWq5NBJBcy0Q2H0y0vBBUEjT9VcsV77pEtlA7nfQ1nNfugw6itdpPMhgHvu6Xy8
	xlwplA4lvT/QlROZ4pBl5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770134194; x=
	1770220594; bh=wVp/m1Quz3BoFMxHOwcVsiCA1igA849JUDKjUESuUCI=; b=O
	JWb7E3dwDuBQ6Oh/fanhwytDwxYiKR6r11AqTNLy5OhVBQErVkwFgzGKxHoYe2zz
	o82K2wG+06gOsBmKY5NRYuJb/QcCasNW7D8HB7O9GJwMh9JqUOV7c0UDorJHc/Bp
	+s+GQZjAiyyTe381spHXRC230fQFfb7ygWGWB56kYKaZa83Y/s12J99EpOSyLvIb
	Ms+FV7rq/hMTZNGatMKQ0CAqUKjXl3tDQPgKUcFl7UhAgtExCLOyr/FT3Dj6xpt8
	MAaHIYx0laH8z+16bCyFLtgKuxKsKLjbjBVcd4gKYvktYBmWrZH8I21dTaWjBN37
	FEaLhh8wF8UX0Kpq+AP9A==
X-ME-Sender: <xms:sRqCacLh9m__M0jBZiOdRimC0QMyHgO-yiWLQtGf2NDfb1PeCbs8tA>
    <xme:sRqCaW8_WbGQ84P6d5sjzJTC6BJj3famktU7GmylHEjP_EqWG4E9HONeIjar5f-OE
    1Xl2lsmlqtSa63V8FVF2Kz1TyO3FCZTGHqBgOHh4kiU-jyzbDXHy_kI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukedtgeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehmrghthhhivghurdguvghsnhhohigvrhhssegvfhhfihgtihhosh
    drtghomhdprhgtphhtthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhrtghp
    thhtoheprhguuhhnlhgrphesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlkh
    hpsehinhhtvghlrdgtohhmpdhrtghpthhtoheprghrnhgusehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehhohhrmhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehjlhgrhi
    htohhnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmhhhirhgrmhgrtheskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:sRqCaVgDVOeKcF55yIUFru0feO85XZRvRZP4d41NA7qVljXYrdsOtA>
    <xmx:sRqCae5TuNvu4rKojfZVpIOMUJTk5vD4mfPC3nY5AjGkG8YH6W0J5A>
    <xmx:sRqCadrYlx_rFWW6OA7wAk2Fyl10hAAqlWbEDD36CXpDQCZqJTyj4g>
    <xmx:sRqCabh_drFWdOszV0LArB7FQ_8FWUiHo3g4y2ha-bxOY6CGFQ26LA>
    <xmx:shqCac_5xk_bEmfYmm4PuL4Xl8VeV31qK2nsZXYcEAo1LfxXpEKFPBI5>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 772E5700065; Tue,  3 Feb 2026 10:56:33 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ATW73pPHePWN
Date: Tue, 03 Feb 2026 16:56:03 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
 "kernel test robot" <lkp@intel.com>
Cc: "Arnd Bergmann" <arnd@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>, "Simon Horman" <horms@kernel.org>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Anna Schumaker" <anna.schumaker@oracle.com>,
 "Chuck Lever" <chuck.lever@oracle.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Linux Memory Management List" <linux-mm@kvack.org>,
 "Randy Dunlap" <rdunlap@infradead.org>, "Yury Norov" <ynorov@nvidia.com>,
 "Joel Fernandes" <joelagnelf@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Message-Id: <d777a8f0-41ab-48f8-93db-268f493ac656@app.fastmail.com>
In-Reply-To: <aYINAPJS9zXlUGCw@smile.fi.intel.com>
References: <20260202095834.1328352-1-arnd@kernel.org>
 <202602032036.FQK7gJvV-lkp@intel.com> <aYINAPJS9zXlUGCw@smile.fi.intel.com>
Subject: Re: [PATCH] tracing: remove __printf() attribute on __ftrace_vbprintk()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 911B24000E
X-Stat-Signature: 478n3uyeifik4ur9m6pur6i8p6u9tzzo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770134195-136716
X-HE-Meta: U2FsdGVkX19F0zxGRK3s3eM107zKxUx1K0vBFyjVrrka+09hUXsw7EBS0FHkusr447UsnPjkqjyHGSMeVtg1qqY7LJDEU/lpd00edJjukPJZ/p4mtO8mUKbaCtmqB+HfaIVB5IcK2bx0zYO3SxOZP168LZ0O00sPne2dHhbYqOMBcYd5ZRmDmpnYUhZI8TlvFyfBLGQKYobBdTJ4NWpTc7g+SkOHH9YRUESQtxDiCacmOmz9aKOe1J+LCtdo2Ke4l8TC3oY3cL7ipPJ/BTFnzhW1LohUHXkPVE2JJv8N8euE2DsbOQ2JYcZJGc0L7Fvll3Uadp982q0Zap+xA7TIX7MjI6gizKyO5DxxgH8llL2jDxxcInX91SbJoj8WUQUcbHr4HIDsGiOfUzNPHEQP/UwndLaEDe2GafTLofCw0f/jK04ztFxT5lgSmqELxVRZz4ULXtgt4YZRpmz14+nt3Y4K8JXONJD7eMdtj97ud59si0L7ppZPbpEgbgNwPtKZx3mTymaZZA/wdeJRNiAgJAQ4sr7ZcEgdoYBlerQmbtLp1FznHtjUODzp+AkyqebitWKKhhdDmczynZ53TQH/rkx9UtpimlRDa4r2bJXkw/3ZPAZPTgKFdaQnIINjREhhk23zKmxU4F5VfDveUzQhJJ05CKdwsXEF2o6QOr5lyLXTeWO+eOTHoLOQJXbSbrotxPt2dv69R/e31a9+z5+FxmiyltPQVigAAvNX8A8zqXNYzwLpwX7U/VAGG6wyaW3KUlXYpCFnbepiniSbLXJdCZHsXZZ91KLy074HWBNr5zblkOTyjxIy18AEDKuxTJAc2788QEE9C1zpmY5P/Oew6pO+JUbnVNO0tf+2hpiZCm6R0I2x6IvjsLw8DkadlL6eDqiLXwXkMPQOSkK/rr/jYCfjlY8lnWrXPFF2nUuaj72D18q9yltnB1JkJr2e6ITKOea9yDA79DjHxXHtV6d
 vYJ2fVhj
 bPemKwb2UUKWPo+alSQaNEjDEEzZFUhLJrL9ZcH6EkuQc0n8Htj0C8U8F7LRadwjUdfTbi2ytr6+67TbnRqMSgF+/3RX4E67/r+YPlTGL8+wPIqca8vT87ffuce/dr6S86HQO9lxjWXljfMLY90GVm2oCqp/s+Dj8kcXhogrN2nZscwqH1XwIYFlKqd12W1KD250h/F60Dp9BWFDAquS29h2gDlZVBtbTNfsnM42iOugextwPzmNcFig9AlevtlIr4tX0toCJ4DE4ar1x/gGkPN2NUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026, at 15:58, Andy Shevchenko wrote:
> On Tue, Feb 03, 2026 at 08:12:57PM +0800, kernel test robot wrote:
>
>> kernel test robot noticed the following build warnings:
>
> Yeah, you need to go for the full stack of these calls and mark the 
> bottom one with __diag() to avoid these warnings. That's my understanding
> and what BPF people required. Chasing this one-by-one would produce
> unneeded churn.

From what I can tell, I can just move the printf attribute
to the __ftrace_vbprintk() definition to make this bit work.
I'll send an updated patch:

--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -197,6 +197,7 @@ struct notifier_block module_trace_bprintk_format_nb = {
        .notifier_call = module_trace_bprintk_format_notify,
 };
 
+__printf(2, 3)
 int __trace_bprintk(unsigned long ip, const char *fmt, ...)
 {
        int ret;

There are unrelated warnings for BPF that I managed to
shut up the same way, doing

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b54ec0e945aa..45d026fc4e8a 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1046,6 +1046,7 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
        return err;
 }
 
+__printf(3, 0)
 BPF_CALL_5(bpf_snprintf, char *, str, u32, str_size, char *, fmt,
           const void *, args, u32, data_len)
 {
diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index 24730df55e69..816fd7fba3d2 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -212,6 +212,7 @@ __bpf_kfunc_start_defs();
  * Avoid using enum bpf_stream_id so that kfunc users don't have to pull in the
  * enum in headers.
  */
+__printf(2, 0)
 __bpf_kfunc int bpf_stream_vprintk(int stream_id, const char *fmt__str, const void *args,
                                   u32 len__sz, struct bpf_prog_aux *aux)
 {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index eadaef8592a3..2d3de71ab86a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -359,6 +359,7 @@ static const struct bpf_func_proto bpf_probe_write_user_proto = {
 #define MAX_TRACE_PRINTK_VARARGS       3
 #define BPF_TRACE_PRINTK_SIZE          1024
 
+__printf(1, 0)
 BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
           u64, arg2, u64, arg3)
 {
@@ -412,6 +413,7 @@ const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
        return &bpf_trace_printk_proto;
 }
 
+__printf(1, 0)
 BPF_CALL_4(bpf_trace_vprintk, char *, fmt, u32, fmt_size, const void *, args,
           u32, data_len)
 {
@@ -455,6 +457,7 @@ const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void)
        return &bpf_trace_vprintk_proto;
 }
 
+__printf(2, 0)
 BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
           const void *, args, u32, data_len)
 {

Since those functions have no callers, the annotation on the
print functions does nothing.

With those added, and a couple of drivers fixed to use the
correct printf attributes, the only remaining one I see is
in samples/trace_events/trace-events-sample.h:

In file included from /home/arnd/arm-soc/include/trace/define_trace.h:132,
                 from /home/arnd/arm-soc/samples/trace_events/trace-events-sample.h:640,
                 from /home/arnd/arm-soc/samples/trace_events/trace-events-sample.c:12:
/home/arnd/arm-soc/samples/trace_events/./trace-events-sample.h: In function 'trace_event_get_offsets_foo_bar':
/home/arnd/arm-soc/include/trace/stages/stage5_get_offsets.h:33:31: error: function 'trace_event_get_offsets_foo_bar' might be a candidate for 'gnu_printf' format attribute [-Werror=suggest-attribute=format]
   33 |         { (void)sizeof(struct _test_no_array_##item *); }
      |                               ^~~~~~~~~~~~~~~
/home/arnd/arm-soc/include/trace/trace_events.h:285:9: note: in definition of macro 'DECLARE_EVENT_CLASS'
  285 |         tstruct;                                                        \
      |         ^~~~~~~
/home/arnd/arm-soc/include/trace/trace_events.h:43:30: note: in expansion of macro 'PARAMS'
   43 |                              PARAMS(tstruct),                  \
      |                              ^~~~~~
/home/arnd/arm-soc/samples/trace_events/./trace-events-sample.h:291:1: note: in expansion of macro 'TRACE_EVENT'
  291 | TRACE_EVENT(foo_bar,
      | ^~~~~~~~~~~
/home/arnd/arm-soc/samples/trace_events/./trace-events-sample.h:299:9: note: in expansion of macro 'TP_STRUCT__entry'
  299 |         TP_STRUCT__entry(
      |         ^~~~~~~~~~~~~~~~
/home/arnd/arm-soc/samples/trace_events/./trace-events-sample.h:301:17: note: in expansion of macro '__field'
  301 |                 __field(        int,    bar                     )
      |                 ^~~~~~~
/home/arnd/arm-soc/samples/trace_events/./trace-events-sample.h: In function 'do_trace_event_raw_event_foo_bar':

I don't think this is related, but I also don't see an obvious
workaround other than forcing the warning off around that
definition.

       Arnd

