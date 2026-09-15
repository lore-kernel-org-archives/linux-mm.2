Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86BF7C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5F76B0093; Tue, 15 Sep 2026 10:55:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8307C6B0095; Tue, 15 Sep 2026 10:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DDF6B0099; Tue, 15 Sep 2026 10:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 500646B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:55:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE51D1603DF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:55:07 +0000 (UTC)
X-FDA: 85216294254.05.807EF7D
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0B0731C0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:55:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cUd2mXY0;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484106;
	b=gUHj34jdRDUDhAB/Jdcjh1X0wdK1j0PoTXZLuFkqJeQVbi1UmfD6Rt0YqXmISFdqnsb7X3
	8BQRSABaLkQJ2bf7TAKAXOCQpsmkyjBw7qfUA1IZPJHYoRQuD16I37544dfrTwRX63q0b7
	C9Z7uiHSFr8r1qG7Fi5P1BrCYdyTPM8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cUd2mXY0;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUhDI+dzHo2x9QlE6sWGtPeMOZNYE2a9quEmjR2fQ2o=;
	b=ZAtEOD933FQVMmKpkKaghYSZjIFuD41ol7iIJSXKBTxD+lmqstUP0XqKMbWI1uqMiW9693
	Kug/xQQPzlrHimCscRxNLITr/GWh7pGN/yRb+Do+aAoAxbhpmmV0DwLWtAjHhFl0Us7i/d
	EQvQVh45XrKApNJS+mTP/o/HInwE9Uo=
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6056ac81fso714227a12.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789484104; x=1790088904; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zUhDI+dzHo2x9QlE6sWGtPeMOZNYE2a9quEmjR2fQ2o=;
        b=cUd2mXY0wm8t5VZZvWu0OtOaKTadMPy0RZj78ofRpl/AV9BR9bsQMu/hk4WxnxYFOD
         mGnby2w5vvVPAsoGHNBKiLJWkHdbtc3uI8KSMFcMczDJdGL9+zSwY8PHQVB9fCfNxXkR
         dRrl3XQjvHZCCYw3EhBGvuyrNUwgiTW80+YAwrGkqD1Hx4Ajh9BCAiI0ToKKFqy91CZv
         yLS2jve7WG4O5DJZZ6CtUs4babwv2Coeap51kkh8UfX7dYoutjeFLqeqvSE0UliiGuTa
         fhtLfg+EyiIT62aFf9eW547/qP2230VsOlO5dFpmE24kAXoFxOu0sUubvuBKSW+I7lmt
         X7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789484104; x=1790088904;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zUhDI+dzHo2x9QlE6sWGtPeMOZNYE2a9quEmjR2fQ2o=;
        b=ywAHP1rj+BWgrO21rP+i0eRze5qaF47AH+4zkRG/8o+c0Dxhy7NRytBmK9bR78BrcE
         CxokSiHP9uWQ4G8buMlnN6hFbgOxp7FbiaUwBDIYpZUagZOfIfuc1tlCOwScvTYCHvt3
         692u8hK7gWZcUuj+Ghg/usvu5mkthe0J9QASpBxtmjRdFMZC2oVlPmIpgT2nAtS6VMvo
         4ZdXkQ5hnXDm4/Wz3rgwtsqmOv7IjlWG5bM541Di3Z6r9v/iZcQ+fplaATzFWo99pMUs
         ZhanKfCwx/R/OiaceDaim1qcI7roKVf/0ZFuozPZumbkPVds32Z+E5sOVvbQj3hN1eCN
         iwzw==
X-Forwarded-Encrypted: i=1; AKwUvBxCss5oEYlbLA2JBIMo+bU9Cuk5kVH3xpPlBdCtiWuHh58kJaMh9oHkmSHpJIzgENxmI4VnQ/vgUA==@kvack.org
X-Gm-Message-State: AFuF++kbmKq+UDMg0hQasqE71gZJQSP7JRsbdv3VZHm0sPLdk42R4H2Z
	DSF1fPwNT5eRKQEdIQMP4OGrRfdGfy4L+7jOfYaYYKYeiwGJ5TVMgOG5
X-Gm-Gg: AYBFou3vAnD9tDSG30RXDBEfIs0bpDZ5aaspep24F0kNSjm/auIg+tnLhakQZnWMQej
	fz/eSsZBDuE5R1ys/oLwie/GLAKw7Ro6bFqFuijOw5crojVbixx5381hZbeqJcSgkqQGkavMPqP
	eTRWf+yvLPoHm3wZd2jiVM5v9R+NlpUhSPmMxaDb2xU09SIHTkJUQXgvtKGrdv1sQo8ci0Taotj
	e3CXsQ4s1lOkJhPGfYqkCGzgTsvlR/snzewr3ZNG4ikeE3tMHmAmYoZiUQoQOV4xijgAbWeshZM
	1JWhCOFaLrge8PFIZOmLNy+ZnBE/XLFD3eX4mj7mQVUBxQO9vD8MisXJhXmA2aulUqoJhraiIQY
	noD4mUacN2VI1ylP0F4dyZmzlGLg4pAR8RDRZNEQvNCzjeD46IJbjdwSCT+36c6pZDQQMSzoecn
	S0eJScB4aqMetqz9hSQQy+oP7g4UM+/dDqGYoz
X-Received: by 2002:a17:907:1c12:b0:c26:19de:9adb with SMTP id a640c23a62f3a-c29d78edda1mr121688666b.26.1789484104486;
        Tue, 15 Sep 2026 07:55:04 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29660234f2sm606861766b.12.2026.09.15.07.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 07:55:04 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 15 Sep 2026 16:55:02 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Ye Liu <ye.liu@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH 3/3] mm/vmalloc: extract show_busy_info from
 vmalloc_info_show
Message-ID: <aqlcRjH9JStZ_eJD@milan>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-3-526f68559706@linux.dev>
 <aqgqjRJ8qpYmx04v@milan>
 <20260914213824.2b5d9af8a5be89fe09e1629b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914213824.2b5d9af8a5be89fe09e1629b@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B0731C0006
X-Stat-Signature: u8sawrpet7ftk71pf9xu986bni1rhwuz
X-HE-Tag: 1789484105-207678
X-HE-Meta: U2FsdGVkX1+ZDMVT84PvJSfTngW+cV9bMZly0rrwEBoc+U6C3+PkNo396qtIut2Y0r37mqkiM5Eb0fukfeGpVlekLNnYZv8fWVMTUpXQn/ff/GU/ma+P/vgEjRg4hExufyOUUqJfWNjree7anTo9fN7kpnTliGGqdx5+NvClR9a6GKitLM7doZvIR7BSaicpNYoOIpJMnN4yADIq4/z78DZAtDuE/vhjGkVO0qdZJJRzEDZXVGIbyeLj5tErDKlW/5IGyyCZqdPX0UJN23sOn+gBihvi2j1UARoCkV5TzNabQ+yOND5N5ewPRPuAJCBeJOvekPYCW8uT9OOkWq9/NVShBO/luclgrf4BfsJdGNCoirUD/N5K/Ajlk/fxTzfEhuuYVKa9lTI7zqVxbeQ08o/VOEY7hgw4TTAPdrC6xeKlqa88lG63y221nOklxEi5hQMXHKs4nhgvaEtqsoZpkz94zH9bM3mIU3qpPXpBdYJP9fDQmxcODFTV0qdITwEceLIDYCI8yKEHqN4Zt23JGS/Adh25IK/Fir+Rq/PNOM1f8Nzgo3qXUngzyBRMLM99kh5Mg7srSANc51JjMDkobkshc5rznl1GMWC5fxOYo/RpcctKydDOEMsUlLHwJji2+J4cYAtrvt/Q9UZX5DHFnX1USoga/BInyafhmMVxDBX0zNZ1Guirzft5sp1QdI7po2fBbDq9P/tA4UhWhQqMGvShfZj2ApDBC0flT04Yb6brsbZZcrRk+tJM+ts7pNOZGASMhSSIALZ90/kKb9V868mc53lacNxEh0pSdmJQbbPsIjm37smcl5fUK6Tn0GRpJaxd/BMnwdxY2PDNg2BZnGZPHZl8JgGqptaaBCX1oB5cOaMOmOINeY2XrSRyJY76CVgi6jJOgRb3JOTkDw0jD/SfUS5LT/e77ZZON2zq3xeLUa0Wcq4K2K0+PxmmKUPrpqw0LS5kyjXYDgnD2wb
 8qahg5K8
 PbiCf0ejklKHniXlIRsLJffhZNJv48Q0bfd5t9dwgYCN053uHG1EbiV0ic9nU2As1uA6Pff8nX4PiiigBBWeREMy+QyWn5H2aKSsrES28WEESYiNO7fkhsMnVU4u0NnPy4SUZsXwLu2HTZlp6/kAbehEwRAlB+3cR5nu+IOiayxEud+QFWC9NiAoAJ7MziAYrXqU2peF2vxXmMl9qwgTS1dBvdnlBeNPag5x0ZENNFqiAXh7yM6cLflJKs0HaPjxPluKVtZqSinS6x83UCy5Jko+UAdphFSy5ArAtIz9oxuwvRipF7mzDm2U4mkFs5IXkT5xIYYNcsSFO+rKtPxV6j2AltYTdIrLJNmUVylsbC3cCanqaew1oN3pIQEKolHje2tGP2ZkIHHMddmuN3wG4402Xv1LhdgHxYylQRgFLX9+ZSCc55lyt8tThmQZ2G7IENV2yM8UjWxDHjPuO0ecP0BewC+tTMfXL4vfLrbbmcGgB3Yp5h8++urUwIq21QEw3tChJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 09:38:24PM -0700, Andrew Morton wrote:
> On Mon, 14 Sep 2026 19:10:37 +0200 Uladzislau Rezki <urezki@gmail.com> wrote:
> 
> > On Mon, Sep 14, 2026 at 11:34:02AM +0800, Ye Liu wrote:
> > > From: Ye Liu <liuye@kylinos.cn>
> > > 
> > > Extract the busy vmap area iteration into show_busy_info, mirroring
> > > the existing show_purge_info pattern.
> > > 
> > > Signed-off-by: Ye Liu <liuye@kylinos.cn>
> > > ---
> > >  mm/vmalloc.c | 14 ++++++++++----
> > >  1 file changed, 10 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index 797933ba9451..7638845377f5 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -5345,12 +5345,12 @@ static void show_purge_info(struct seq_file *m)
> > >  	}
> > >  }
> > >  
> > > -static int vmalloc_info_show(struct seq_file *m, void *p)
> > > +static void show_busy_info(struct seq_file *m)
> > >  {
> > >  	struct vmap_node *vn;
> > >  	struct vmap_area *va;
> > >  	struct vm_struct *v;
> > > -	unsigned int *counters;
> > > +	unsigned int *counters = NULL;
> > >
> > Is setting counters setting to NULL odd here?
> 
> static void show_busy_info(struct seq_file *m)
> {
> 	...
> 	unsigned int *counters = NULL;
> 
> 	if (IS_ENABLED(CONFIG_NUMA))
> 		counters = ...
> 
> 	...
> 
> 	if (IS_ENABLED(CONFIG_NUMA))
> 		kfree(counters);
> 	...
> }
> 
> Presumably some dumb compiler or checker warned about
> kfree(uninitialized-val).
>
Probably.

--
Uladzislau Rezki

