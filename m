Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7539CC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 18:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139F26B0089; Wed, 30 Jul 2025 14:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EAF36B008A; Wed, 30 Jul 2025 14:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4E56B0095; Wed, 30 Jul 2025 14:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD5CE6B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:52:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7325011423B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:52:51 +0000 (UTC)
X-FDA: 83721827742.24.786944F
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5912B16000D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:52:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Mt0lA7iH;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753901569; a=rsa-sha256;
	cv=none;
	b=4M0h8z3hkxn3J9uZx2BocCy5fNNHJbdCp+x8aJ4lrbWZ/RmODKfUe28q8N/CzsdjvrQ7QS
	UC4UklT+FHTOhM+Beu0ipgKEdmYWrUy2dsWHqrp1nCud3OHLAeRsH43K47SqHSu99hJBW1
	ZIUl0MsKA476eX68IyawxV23VwT7wkY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Mt0lA7iH;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753901569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slAyeWyqtgn0qVMjTiorxiyOrDOZnrQB9QTmFJ0CFeE=;
	b=ry5z/y8Z1lUXsE5TMl/KEk/TgJZv313boznGeNqjrDUi/fZEvEZFIOhLBl9xXODT56vqjs
	t2mogIV9tNTkOg6xJk+rx80Tnndrd5PmkRIyrzAf08bKwRylx3zXb5Ycd8B/SOHo7oY2Qx
	pC7sb72cE9Ytx7qtDOHo3UKz7FyUtC0=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-af90fd52147so18416466b.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1753901567; x=1754506367; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=slAyeWyqtgn0qVMjTiorxiyOrDOZnrQB9QTmFJ0CFeE=;
        b=Mt0lA7iHAboab56CH9LjOycZUFJi7YfFRG2UmSNC1P8xeIijJ5yKzH3u8exiASOqLK
         cOOd3aGy//nZoDJYBWjszTvZ/nx5LrxO3pbOhiexqH5Q6LXZE1Nk0F3Ri85uv8XmQFIa
         Z0wpJU07uyjI1XqMDEVOUuIYlHqIemxAP2VEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753901567; x=1754506367;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=slAyeWyqtgn0qVMjTiorxiyOrDOZnrQB9QTmFJ0CFeE=;
        b=Zzq4C680/GchATRgKNtBUydwiPWhR7c4bSWYqRgZK+xIRDrYXe/tDIN3P/g0RmAMf7
         d7bdmhjC5jkCLLIbi8i7WDXbtFEpcjDWFejZSY1wpWWAc3jjaY2Yc4ySb7QUAUB/16w9
         FSt6Wtr1eHFZ5qAFjScKHVeonJR+6JFQJ+NAGmtxR6Oilr4lmWUrGi0m1s0YQmetfnM3
         sSrR6lUDcJXk9/Vrd0smrZzWC3bVL78ZFFqFVHVyuOIS8Q9sSr+G/H5Uu0snLxiYECsO
         Fb1YxQ3hA3bbXb5PPvJmnW/jqQJGWjtVElCKABCX6R1HGSOPQruTss+L5sbWC0ehoEzT
         m3PQ==
X-Forwarded-Encrypted: i=1; AJvYcCXod6tGkIZo393d/deAxHKwzIqHIZygSFy1sCXaIxeOHghKu7uDhV7RqqfDXOosgJaDDnkikXYEOA==@kvack.org
X-Gm-Message-State: AOJu0Yz45m+VznVriDmDwr0LdONy5kwNLklkEbCEf8BwONEhqqvBDJrz
	ecHzNqRC0nVxETPh0MYn0xKxvCGqilOdlvmE6IMuXHY+WL3CFzKWE04oDEeQcZ316WOwuiV5zea
	MXyfjkiY=
X-Gm-Gg: ASbGncvFVOW5oEeWcWCBnPfish7jSRHQj/O3mTxELxG1gmrMM4+Nw6vlglOK74qLt8L
	QBgeZ5ArrCs0aPBiSQpcE2MlT0guKLELmKDMWco3mCo57V6CbrC0fqkGkBOKaMFRqgtBozvP5OG
	igGmGV/zlWjoI1v58pDq3O/1Wyl6PO8QWo371ZFOV9Jv17OIDRt6smBo9ivEtF9SE5rzes+hBej
	Jqg4oDpBRI9R4EjPiJclao9BVAeWj+HGlkjuxIc9zw2+q9n36f0bPzDR52o7eFaapZBoIPON2rg
	DCS5LYFkvw8NTeOPm6SefST44d0M1BPp4+Q3JEDOqz/jMkNAAGdNAxa9ov7CX98fTLi8fSSx48H
	QeAIlsP3/p43jbNn7NA+ju0gYaqUIpUbOP03OZ9x9esp2KZrXiSlN7XsvOb75h+xAU6U6zqL4
X-Google-Smtp-Source: AGHT+IEicBK0/RgDw6xUFOloTu5mWDEoxULaIMenxo4QvsDDj68Wt0wvPQKQu4hssmKI0XPwmsc4SA==
X-Received: by 2002:a17:907:6093:b0:ae0:d1f3:f7f4 with SMTP id a640c23a62f3a-af8fd6b23eemr502542666b.13.1753901567665;
        Wed, 30 Jul 2025 11:52:47 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61536916dbasm4667996a12.43.2025.07.30.11.52.44
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 11:52:45 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61521cd7be2so96005a12.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:52:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXziiklRLwJiJnaTpwpzxyAtR3tZmq/bZbU9JvOn0KRHabP9RHvdFsL93zKT2XyZKH4sg7lVZ82mA==@kvack.org
X-Received: by 2002:a05:6402:2708:b0:612:dfdd:46fc with SMTP id
 4fb4d7f45d1cf-61586eecd21mr4741613a12.11.1753901564582; Wed, 30 Jul 2025
 11:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz> <CAHk-=wg70=mihHE3_Te=t1Fmvrh22bcEs8bvH3tDEXZd6q+4_g@mail.gmail.com>
 <20250730184724.GC89283@nvidia.com>
In-Reply-To: <20250730184724.GC89283@nvidia.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Jul 2025 11:52:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh_ukn6ESXTLKR9+g9hxVdop0sMe-Hu7AS8dinXGvYhJg@mail.gmail.com>
X-Gm-Features: Ac12FXzOpWstClby8n_gZ1wN_LSRv3bSws6YzxdQ9YiX4spwxDywE66Yp6AB2ZU
Message-ID: <CAHk-=wh_ukn6ESXTLKR9+g9hxVdop0sMe-Hu7AS8dinXGvYhJg@mail.gmail.com>
Subject: Re: [GIT PULL] slab updates for 6.17
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	Bernard Metzler <bernard.metzler@linux.dev>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5912B16000D
X-Stat-Signature: pte5kya9pg6sy8cna9cok5jq8da6uj4u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753901569-809952
X-HE-Meta: U2FsdGVkX1+EBIIIW1jUP2eH5flllzUvHPovl4Fo+l/HIgaocVPtN9F+PY9+sVCpXYDPd2r2RR9fVJUsc/GAETWcxS+8oV+RMUXTTYQCPO0jGw7cFlmQBldie6PWNvkYTYUcrbwk5J2q9O5Py945xtlUhFzk54EaFEHVnrAKtNzcG+q3atP8Zw/mOJERvAAmeNrmgQmaRFM5ypU3aJmMYk7P/yTwZHeBWFwUzgT1HQJbq4jIdV46ZYb7QrHMy34WM23Eu0yuWKaKNcarmo/CmBy/4jzi0xIHLtAj6mgM+iaicL9mxtp4CODzwUiX/q+doG+IZKCNq04lLx1A7qSkmVHV81I5ZZ8Ljq31p2T0GBBoSybpBfdzYhE6h4CULNKNHP3VNXapClVbcDyEvMEZvz/9imSlAfK2qVfVhfL1ScJmKy29DVCwYK92vzOIsuj0F6xkShXC/PkgGKjWImeW521Vbsjxd/9D7OtbJPggVOcg3xZMsb4LD9WPlCR7lot8OZvIW2omW2mLQOJYg8fOwUMD2GevKDm3cTLODsSchd2cg2BHJLTSqoiqIlsXmVzYelu3OjY2fZr2igWYqxyGW1+WrpWsyLtgyyi+1x8eCCsk4MuIWZRzeExya6U33MBnQdVHb/uBcPAsLSQlrznJNYF+e8VC2rQoMTGwK1fcObRv6D/6u6XtehIBmzUqZ0KRvGOXhBRC+BGXyPxjWawYaOwa86mD+Km2vQwHxTejExwe0XWSSIzJck/6jwBWuuLM+ro9eGKg2R+qyfak0Qeo9uhIorzOrnwpOxM2GChyMnGgyIYttR5m3UouqABEo8xQDvKoOhjUIbaadidU9sIHQCVvYkhOqKtnwsXrkC3V6lboUe9vtUPL2uojXTna63gyuD/FZ5MXwV5kzCCC+k5zyU5gFpNvbKFPjOKue+PfvGMlLPLAgcySVEg7z98/z+Ar4HiWFSkhIoW1FXOwRaV
 qcmK4Mh2
 ZITKmWFLfiYj5REhPyeG+0EFeHiFWQ6NsbDmMZRSBlUfwkM/Udg+LaN+YaqxtdL0rPNz9DcW0Uk29BT9Yl4C+cbAAfzGcB2SameWDlhqgc8d/kRbX4wAyiTh4CF9w0eKFgAIZ3rhJLyyt3XkMZwdtRHOtCJ/2gTriU0bBxXgwpp9ia51Yaz/81bPLeGY7eeZQhTggDW0K9UFiOuCDkKnZX7l0ejiTA/nvkCNUp1JfPfnuiTYMU1S9e6nzvc7VWLbVFZDyurMvdlBpdROlOfVpwU+nqlhp8fpDU0BZwLB354KGH6Mxg8mnj/OO5+d1eYRjXIZ66dSaFWraDtszO4gT4P8d+aRvZvVKp2yRNmvpbg5p9iMs7IYT7yl0hiBdNJnjGNqxOewzQrNF3pPIeCDop6rko3sGWu4eVguvPkmQf/CKroQN1ubkU+FHzm7rw0Mp1pQjz/Erje51xA1w+gCfmqdG11Tvp7a1p80BDJKHQWP5tj2IKzH8u7WPyFCR3cmIT7QRdB+TMAa7kp1pcNFbUeA4d6gBcKqTCS+0OQ6R0eiKgC3zynNF0jvraM/87JIG9e7QE+sWl5b2rO4ir9n5gGXCsd/bnW953dvN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 at 11:47, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> I think it will be easiest for all if I send a one patch PR after you pick up
> the main RDMA PR in the next few days. siw is not so critical that we
> need to rush.

Ack, sounds good.

            Linus

