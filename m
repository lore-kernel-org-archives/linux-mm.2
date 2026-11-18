Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D557606A338
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSexoLIK
Received: by kanga.kvack.org (Postfix)
	id 6829A6B05B2; Wed, 18 Nov 2026 13:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6123E6B05B3; Wed, 18 Nov 2026 13:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485B16B05B4; Wed, 18 Nov 2026 13:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEB16B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:23:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B0DB120836
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:23:11 +0000 (UTC)
X-FDA: 85449061782.11.5BCCC19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0371D100006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:23:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSexoLIK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795026190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foArwJppdw7wxwAIXrJloa09SFBAq+aNRAw3uRfRo00=;
	b=V9UuEacBlo5o6GJKblw2YSaqeTy3/gT6+imRPOM/H5XpbVCYfc5AulPJkqU7r1rDPYbXfA
	RgZ9i9Z0a4GWggwN9eu7vTPySgMqOKxd3+O85KGpfw9dmPSjvSsnnoF/bV+KxtyG2NHu9w
	hE22ztt7VyuQxznw+PvZaB6F1sf3s+s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSexoLIK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795026190;
	b=v4suECGVD4hD79qBBXbAjhb93enghDpXjE0xBPOAD0wBdC0LcW1Bh/6bXYgS2uqfqaWWJU
	E78Kk4q/fRf8fRRDxqNVRIzGBIaRsPmKThmYdpZJredD+e6Hruk+j+ejzAiyXiOIVgmlsK
	VCmlS6w+S7+2Uc7yXbPxHvWCB9r6fkc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 7066963677;
	Wed, 18 Nov 2026 18:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6DD3E1F000C5;
	Wed, 18 Nov 2026 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795026189;
	bh=foArwJppdw7wxwAIXrJloa09SFBAq+aNRAw3uRfRo00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SSexoLIKwBoPiLX/UCNvXMAvv4Xqx3dXaulr2O2mznCKKpg7Gl+XFyR5jDdZdWAUN
	 Bm2Ym5u52HNVVRFXbz+lZpqqUqdI0QIVX/BnBolTVOjdqbWIRa9ZL/AQfHb7tP0tHy
	 Bo3R6lGQHJTvQrtUZUBLV22APvmXIw2J9PMILe+xCzHOUZKAi5UWfm9zvRyK2Mg+0I
	 M+H6ts9MMhrB3C9VnwqV5X6yDzwsL/MkVrIZfX8RVMJAzd9mqBMK3WoZuQhU6CTmSZ
	 37+m6Xg9yYUbnkS2hE09G723J8T6okkYA03L/UmQUJFycH5/CD9SmRDukHGn7s1/6U
	 Jq9Ur6XjHy3ig==
Date: Wed, 18 Nov 2026 20:23:05 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: josef@toxicpanda.com, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <av3tCT5lQTu7qBMz@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
X-Rspamd-Queue-Id: 0371D100006
X-Stat-Signature: tw6qxw6txufo8brfo4o5w4boaasj38oh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795026189-296000
X-HE-Meta: U2FsdGVkX19TI0vshJSG54wB8n7J10iU5/ClhQMrj9ayCEgAUejP+LL1BDTynGyBW1mdZkXvMc18/OqmbD/Kkrc6KR+75l2e0H/q15onZp8jsag5pqeXzD8YPu9qD7DG0c+iqzFkEJtUcKZVdZGunzi/+EYEXoKZSiREYZVmFkjxgBKAS8ERk2PNqlk8SbvzZW72qpe4ggsJwg4AJhjBuwX8X7Hrv/K9d6nn9EjWi8UopvYNo89siIMNfR/TRRWyUY58OuKPfxPqVO4gyzOnw9EpZOl3ldWHTMF2HU+yWjT0SOZ0YCIlQNX1/WxlNOf14A7634BzSaZfTf5KB8CFAbecclfO0NmOCiugGc+Z+/IwPJAPllqmYwBVaKEar38LfQLBYgUi3GVZAWARtRmkxk80NafU9veKyuL8/VuO52L5ACuoUcVEcRgoQmhjNBbt1hUiEVRneGp0oXDUahBbeXloVntJ0QrTQ9egpsshQopkszoGlreArL8L8ZC983CUYbtwLYraW6up6PeettE32+zpqVV9m4LioT34KksBv8c/feoZsnd/X8JuT4Cr0JU87WRQvkaGnyRqmnIJFfuu4/pEFLjhWBSR1lcIJ83YSp+9OtpddUI81SizqnI0C7LlYAkpEoGMYfsv+Apc8g3yBPipI2B1WCCBHblu32HOCrNOrG8V1Dwm6W1g0KbXsw7/MPQLtDWH5jZu+BmAyWVIF7WFFYsYFeO52V5b4oaoMBEsLAOcXQR0LtFXnF7T/7doloS7/fw2CueppHtpLL45t4OjGH2r/CYDIRYn/1kQ1LnyRuwr5kZzyQ6vcZ3uz6oqYbmahLbkgFnXtUK3Dc4/tIwvgOrJZj2cbUGTq1m8XXMMMztFAJRdtLbXvnVlhUXBTh5Gy7+wt43ZszoWsbzmLYbyrcQmtjPqC9gScmF6mhcIkC4TR4nw9DGrV9cxf/NJFsurmwkh9b9E2og4h0g
 SDZyXw7M
 EArIfyXUJcDXP/Z6HZJdN/KrJqaNBk8UQ9jK6P4zUt6QJSnAjvrjmKyrc+Evr/lFfQFC7dA7jOpee0E6lyyXNF1UDnfijJAMwWCAJXO5ETEIOBCr5o8srhEiQ51mdsLvx7bIFEdZLdam1wJf+5oHWH4q/S4AYHLu4EwvNKjI8BVKPODL3d700Wch9E1kfT85EL+O35MKo4sOpCuDdBveNHIp1RqeWmRJyZ9Dqpr8JhbyrVOhxGZsoEwq/h/s3Ro6CydkuXYo3k5XbFGVCTmATioqOuUvMTvN/iZRAODxj/7W9jqAN3FSPu9rL3z4G38OxYHnA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:46:02AM -0800, Andy Lutomirski wrote:
> On Wed, Nov 18, 2026 at 9:08 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > On Wed, Nov 18, 2026 at 07:04:21PM +0200, Jarkko Sakkinen wrote:
> > > On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> > > > On Tue, Nov 17, 2026 at 3:14 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > > >
> > > > > OVERVIEW
> > > > > ========
> > > > >
> > > > > A root namespace (rootns) is a kernel object backed by a file descriptor
> > > > > that binds together:
> > > > >
> > > > > 1. A full or partial set of detached namespaces.
> > > > > 2. A dedicated PID namespace for spawning processes into, signaling
> > > > >    members, and polling or waiting on PID 1 exit.
> > > > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> > > > >    populated before going live, without inheriting host mount-tree
> > > > >    ancestors.
> > > > >
> > > > > Work on this feature started in 2025 from David Howells' container object
> > > > > patch set [1], which I turned into a namespace for namespace roots and
> > > > > rebuilt around that premise.
> > > > >
> > > > > While the patch set is manually written, the original motivation came
> > > > > from isolating LLM agents. Running untrusted agent workloads made it
> > > > > clear that OCI runtimes need to minimize their live configuration
> > > > > surface.
> > > > >
> > > > > Assembling mounts, credentials, and namespaces inside helper processes
> > > > > with a half-configured container is what I see as the main challenge,
> > > > > and the existential debate around namespaces and container objects is an
> > > > > unfocused discussion topic.
> > > >
> > > >
> > > > I've skimmed some of the series, and I see a bunch of good ideas that
> > > > involve using an fd to manage a thing.  But I'm wondering how much of
> > > > the value is added by that and how much is added by having a new
> > > > *type* of thing: the "rootns".
> > > >
> > > > How much of the value comes from the rootns vs the new APIs to
> > > > configure namespaces without entering them first?
> > > >
> > > > For that matter, the cells series also seems to contain a (possibly
> > > > very similar) variant of the same thing.
> > > >
> > > > Would it make sense to come up with a patchset that does *just* the
> > > > configure-a-namespace-by-fd part?  It seems to me that this should be
> > > > an easier thing to agree on, and it's a big part of the complexity of
> > > > all of this, and it solves a real problem even without
> > > > cells/rootnses/jails/whatever.
> > >
> > > Is it  more accurately scope the part that is "just the fd-part" and
> > > what you consider as "extra cruft"?
> 
> I'm not actually trying to say that anything is "extra cruft".  What I
> mean is: there seems to be somewhat of a core that is pretty similar
> between the two patchsets, and that core seems independently useful.
> 
> > >
> > > I.e., where do you draw the border?
> >
> > I'm asking this because I had similar thoughts when I started this back
> > in 2025. David had some good ideas but it did more than having a fd
> > that does not go live before everything is set up properly.
> 
> I don't know that I have a very clear border, but here's an example:
> 
> rootns has MOVE_MOUNT_T_ROOTNS_ROOT.
> 
> cells has:
> 
> +What else goes into the tree is mounted on it before it becomes a
> mount namespace.  A
> +filesystem for the cell to write to is mapped in the same way:
> +
> +.. code-block:: c
> +
> +   fs = fsopen("tmpfs", 0);
> +   fsconfig(fs, FSCONFIG_SET_STRING, "mode", "1777", 0);
> +   fsconfig(fs, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
> +   mnt = fsmount(fs, 0, MOUNT_ATTR_NOSUID | MOUNT_ATTR_NODEV);
> +   mount_setattr(mnt, "", AT_EMPTY_PATH, &attr, sizeof(attr));
> +   move_mount(mnt, "", tree, "tmp", MOVE_MOUNT_F_EMPTY_PATH);
> 
> (Source: https://lore.kernel.org/all/20261105-b4-cells-v3-2-bc9095937a84@toxicpanda.com/)
> 
> I feel like you are both *so close* to something that would stand
> alone and make perfect sense.  I also feel like, if that's a goal,
> then both series are slightly off from the bulls-eye.  (Keep in mind
> that I've spend a total of about ten minutes looking at the relevant
> parts of the series.)

Thanks, there was still a lot of relevant feedback to address.

And who knows, perhaps there's a sweet spot intersection. I would not
mind that, as I only pursue for something simple and practical.

For the time being, I'll update this series simply because there's less
to change, and polish the implementation. That does not hurt even if
cells were the ultimate solution. Part of this series can still be
useful.

> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC

Br, Jarkko

